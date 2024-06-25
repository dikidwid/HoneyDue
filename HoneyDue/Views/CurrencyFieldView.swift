//
//  CurrencyFieldView.swift
//  iTrack
//
//  Created by Diki Dwi Diro on 25/06/24.
//

import SwiftUI

public struct CurrencyField: View {
    @State var isAnimateAmountIndicator: Bool = false
    @Binding var value: Int
    
    let isCurrencyFieldFocused: Bool
    
    var formatter: NumberFormatter
    
    private var label: String {
        let mag = pow(10, formatter.maximumFractionDigits)
        return formatter.string(for: Decimal(value) / mag) ?? ""
    }

    public init(value: Binding<Int>, formatter: NumberFormatter, isCurrencyFieldFocused: Bool) {
        self._value = value
        self.formatter = formatter
        self.isCurrencyFieldFocused = isCurrencyFieldFocused
    }

    public init(value: Binding<Int>, isCurrencyFieldFocused: Bool) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        formatter.locale = .current

        self.init(value: value, formatter: formatter, isCurrencyFieldFocused: isCurrencyFieldFocused)
    }

    public var body: some View {
        ZStack {
            Text(label).layoutPriority(1)
            CurrencyInputField(value: $value, formatter: formatter)
        }
        .overlay(alignment: .leading) {
            if isCurrencyFieldFocused {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.appPrimary)
                    .frame(width: 2.5, height: 30)
                    .padding(.leading, 77.5)
                    .opacity(isAnimateAmountIndicator ? 1 : 0)
                    .opacity(value == 0 ? 1 : 0)
                    .onAppear {
                        withAnimation(.linear.speed(0.75).repeatForever(autoreverses: true)) {
                            isAnimateAmountIndicator.toggle()
                        }
                    }
            }
        }
    }
}

class NoCaretTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        false
    }

    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        []
    }

    override func caretRect(for position: UITextPosition) -> CGRect {
        .null
    }
}

struct CurrencyInputField: UIViewRepresentable {
    @Binding var value: Int
    var formatter: NumberFormatter

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> NoCaretTextField {
        let textField = NoCaretTextField(frame: .zero)
        context.coordinator.textField = textField // Set the reference to the text field in the coordinator
        textField.delegate = context.coordinator
        textField.keyboardType = .numberPad
        textField.tintColor = .clear
        textField.textColor = .clear
        textField.backgroundColor = .clear
        textField.addTarget(
            context.coordinator,
            action: #selector(Coordinator.editingChanged(textField:)),
            for: .editingChanged
        )
        textField.inputAccessoryView = createToolbar(context: context)
        context.coordinator.updateText(value, textField: textField)
        return textField
    }

    func updateUIView(_ uiView: NoCaretTextField, context: Context) {}

    private func createToolbar(context: Context) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.tintColor = UIColor(red: 255, green: 161, blue: 63, alpha: 1)
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: context.coordinator, action: #selector(Coordinator.doneButtonTapped))
        
        toolbar.items = [flexSpace, doneButton]
        return toolbar
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        private var input: CurrencyInputField
        var textField: UITextField? // Add a reference to the text field
        private var lastValidInput: String? = ""

        init(_ currencyTextField: CurrencyInputField) {
            self.input = currencyTextField
        }

        func setValue(_ value: Int, textField: UITextField) {
            input.value = value
            updateText(value, textField: textField)
        }

        func updateText(_ value: Int, textField: UITextField) {
            textField.text = String(value)
            lastValidInput = String(value)
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if string.isEmpty {
                if input.value == 0 {
                    textField.resignFirstResponder()
                }
                setValue(Int(input.value / 10), textField: textField)
            }
            return true
        }

        @objc func editingChanged(textField: NoCaretTextField) {
            guard var oldText = lastValidInput else {
                return
            }

            let char = (textField.text ?? "").first { next in
                if oldText.isEmpty || next != oldText.removeFirst() {
                    return true
                }
                return false
            }

            guard let char = char, let digit = Int(String(char)) else {
                textField.text = lastValidInput
                return
            }

            let (multValue, multOverflow) = input.value.multipliedReportingOverflow(by: 10)
            if multOverflow {
                textField.text = lastValidInput
                return
            }

            let (addValue, addOverflow) = multValue.addingReportingOverflow(digit)
            if addOverflow {
                textField.text = lastValidInput
                return
            }

            if input.formatter.maximumFractionDigits + input.formatter.maximumIntegerDigits < String(addValue).count {
                textField.text = lastValidInput
                return
            }

            setValue(addValue, textField: textField)
        }

        @objc func doneButtonTapped() {
            textField?.resignFirstResponder() // Explicitly resign the first responder status for the text field
        }
    }
}
