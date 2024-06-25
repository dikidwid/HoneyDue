//
//  ScanBillResults.swift
//  VisionAI
//
//  Created by Arya Adyatma on 12/06/24.
//

import SwiftUI

struct ScanExpenseValidationPage: View {
    @EnvironmentObject var nav: ScanExpenseNavigationViewModel
    @Environment(\.presentationMode) var presentationMode

    @State var expenseResult: ScanExpenseResult
    @State private var isEditing: Bool = false
    @State private var shouldNextPage: Bool = false
    
    var body: some View {
        ScrollView {
            NavigationLink(
                destination: ScanExpenseSelectTransactionPage(
                    viewModel: ScanExpenseSelectTransactionViewModel(expenseResult: expenseResult)
                ),
                isActive: $shouldNextPage
            ) {
                EmptyView()
            }
            VStack(alignment: .leading) {
                TopBarBack(title: "Your Receipt")
                
                Text("This is the scanned result. Make sure to check that the items were scanned correctly.")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .opacity(0.3)
                
                Group {
                    VStack(spacing: 16) {
                        ForEach(expenseResult.items.indices, id: \.self) { index in
                            ExpenseItemView(item: $expenseResult.items[index], isEditing: $isEditing)
                            Rectangle()
                                .frame(height: 1)
                                .opacity(0.1)
                        }
                    }
                    .padding(.vertical)
                }
                .padding(.top, 2)
                
                Group {
                    VStack {
                        ReceiptView(nameText: "Subtotal", priceText: Binding.constant(expenseResult.getSubtotalIDR(includeTax: false)), isEditing: Binding.constant(false))
                        ReceiptView(nameText: "Tax", priceText: $expenseResult.taxChargeIDR, isEditing: $isEditing)
                        ReceiptView(nameText: "Service Charge", priceText: $expenseResult.serviceChargeIDR, isEditing: $isEditing)
                        ReceiptView(nameText: "Discounts", priceText: $expenseResult.discountsIDR, isEditing: $isEditing)
                        ReceiptView(nameText: "Others", priceText: $expenseResult.othersChargeIDR, isEditing: $isEditing)
                        ReceiptView(nameText: "Total Amount", priceText: Binding.constant(expenseResult.getTotalIDR()), isEditing: Binding.constant(false))
                    }
                    .padding(.vertical, 8)
                }
                .background(.white)
                .cornerRadius(16)
                .padding(.top, 2)
                
                if !isEditing {
                    HStack {
                        Spacer()
                        Button(action: {
                            isEditing.toggle()
                        }) {
                            Text("Edit Bill")
                                .foregroundStyle(.colorPrimary)
                        }
                    }
                }
                
                Button(action: {
                    if isEditing {
                        isEditing.toggle() // Turn off editing mode
                    } else {
                        expenseResult.adjustTax()
                        shouldNextPage = true
                    }
                }) {
                    Text(isEditing ? "Save" : "Confirm Bill")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.colorPrimary)
                        .cornerRadius(16)
                }
                .background(Color(UIColor.systemGray6))
                .edgesIgnoringSafeArea(.all)
                .padding(.top)
                
                Spacer()
            }
            .padding()
        }
    }
}

struct ExpenseItemView: View {
    @Binding var item: ScanExpenseItem
    @Binding var isEditing: Bool
    var showIcon: Bool = false
    
    var body: some View {
        HStack {
            if showIcon {
                ZStack {
                    Rectangle()
                        .foregroundStyle(.blue)
                        .opacity(0.2)
                        .frame(width: 48, height: 48)
                        .cornerRadius(16)
                    Text(item.emoji)
                        .scaleEffect(1.5)
                }
                .padding(.trailing, 5)
            }
            
            VStack(alignment: .leading) {
                if isEditing {
                    HStack {
                        GeometryReader { geometry in
                            TextField("Name", text: $item.name)
                                .fontWeight(.bold)
                                .opacity(0.9)
                                .textFieldStyle(CustomTextFieldStyle())
                                .frame(width: min(max(30, textWidth(for: item.name, in: geometry)), geometry.size.width))
                        }
                        Text("i").opacity(0)
                        Spacer()
                    }
                } else {
                    Text(item.name)
                        .fontWeight(.bold)
                        .opacity(0.9)
                }
                
                HStack {
                    if isEditing {
                        TextField("Price", value: $item.pricePerQtyIDR, format: .number)
                            .keyboardType(.decimalPad)
                            .fontWeight(.bold)
                            .foregroundStyle(.black.opacity(0.22))
                            .textFieldStyle(CustomTextFieldStyle())
                            .frame(width: 128)
                    } else {
                        ZStack {
                            Text(item.getPricePerQtyIDR(includeTax: false).toIDRString())
                                .fontWeight(.bold)
                                .foregroundStyle(.black.opacity(0.22))
                                .padding(.vertical, 0.2)
                        }
                    }
                    Spacer()
                    if isEditing {
                        TextField("Quantity", value: $item.qty, format: .number)
                            .keyboardType(.decimalPad)
                            .fontWeight(.bold)
                            .foregroundStyle(.black.opacity(0.22))
                            .textFieldStyle(CustomTextFieldStyle())
                            .frame(width: 56)
                    } else {
                        let quantityText = item.qty.truncatingRemainder(dividingBy: 1) == 0 ? "\(Int(item.qty))" : String(format: "%.2f", item.qty)
                        Text("x\(quantityText)")
                            .fontWeight(.bold)
                            .foregroundStyle(.black.opacity(0.22))
                    }
                    Spacer()
                    Text(item.getPriceTimesQtyIDR(includeTax: false).toIDRString())
                        .fontWeight(.bold)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 110, alignment: .trailing)
                }
            }
        }
    }
    
    private func textWidth(for text: String, in geometry: GeometryProxy) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 17, weight: .bold)
        let attributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        return size.width + 10 // Adding some padding
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 4)
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Color(.black).opacity(0.2), lineWidth: 1)
            )
    }
}

struct ReceiptView: View {
    var nameText: String
    @Binding var priceText: Double
    @Binding var isEditing: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text(nameText)
                    .fontWeight(.semibold)
                Spacer()
                if isEditing {
                    TextField("Price", value: $priceText, format: .number)
                        .keyboardType(.decimalPad)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.trailing)
                        .textFieldStyle(CustomTextFieldStyle())
                        .frame(width: 90)
                } else {
                    if nameText.contains("Total") {
                        Text(priceText.toIDRString())
                            .fontWeight(.black)
                    } else {
                        Text(priceText.toIDRString())
                            .fontWeight(.bold)
                    }
                    
                }
            }
            .padding(.vertical, 4)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        ScanExpenseValidationPage(expenseResult: ScanExpenseResult.getExample())
    }
    .environmentObject(ScanExpenseNavigationViewModel())

}
