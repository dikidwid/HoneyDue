//
//  CustomTextFieldView.swift
//  iTrack
//
//  Created by Diki Dwi Diro on 25/06/24.
//

import SwiftUI

struct CustomTextFieldView: View {
    
    let title: String
    let placeholder: String
    @Binding var value: String
    var isFieldFocused: FocusState<Bool>.Binding
    
    init(title: String, placeholder: String, value: Binding<String>, isFieldFocused: FocusState<Bool>.Binding) {
        self.title = title
        self.placeholder = placeholder
        self._value = value
        self.isFieldFocused = isFieldFocused
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 5) {
                Text(title)
            }
            .font(.system(.caption, weight: .medium))
            .foregroundStyle(isFieldFocused.wrappedValue ? Color.appPrimary : .secondary)
            
            TextField(placeholder, text: $value)
                .font(.system(.subheadline, weight: .regular))
                .textFieldStyle(.plain)
                .focused(isFieldFocused)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .fill(isFieldFocused.wrappedValue ? Color.appPrimary : .secondary)
                        .shadow(color: isFieldFocused.wrappedValue ? .appPrimary.opacity(0.4) : .white, radius: 5)
                    
                }
                .autocorrectionDisabled()
        }
    }
}

//#Preview {
//    CustomTextFieldView()
//}
