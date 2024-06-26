//
//  Settings.swift
//  HoneyDue
//
//  Created by Arya Adyatma on 25/06/24.
//

import SwiftUI

struct TopBarBack: View {
    var title: String
    @Environment(\.presentationMode) var presentationMode
    var disabled: Bool = false
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.primary)
                }
                .disabled(disabled)
                Spacer()
            }
            HStack {
                Spacer()
                Text(title)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                Spacer()
            }
        }
        .padding(.bottom, 5)
        .opacity(disabled ? 0.5 : 1.0)
        .overlay(disabled ? Color.white.opacity(0.001) : Color.clear) // Prevents interaction when disabled
    }
}

struct SettingsToggle: View {
    let title: String
    @Binding var isOn: Bool
    var disabled: Bool = false
    
    var body: some View {
        ZStack {
            HStack {
                Text(title)
                    .fontWeight(.bold)
                Spacer()
                Toggle("", isOn: $isOn)
                    .toggleStyle(CustomToggleStyle(color: .colorPrimary)) // Replace .blue with .colorPrimary if you have a custom color defined
                    .labelsHidden()
                    .disabled(disabled)
            }
            .padding(.vertical, 10)
            .opacity(disabled ? 0.5 : 1.0)
            .overlay(disabled ? Color.white.opacity(0.001) : Color.clear) // Prevents interaction when disabled
        }
    }
}

struct SettingsRow: View {
    let title: String
    var disabled: Bool = false
    
    var body: some View {
        ZStack {
            HStack {
                Text(title)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.vertical, 10)
            .opacity(disabled ? 0.5 : 1.0)
            .overlay(disabled ? Color.white.opacity(0.001) : Color.clear) // Prevents interaction when disabled
        }
    }
}

struct DatePickerRow: View {
    var title: String
    @Binding var date: Date
    var disabled: Bool = false
    
    var body: some View {
        ZStack {
            HStack {
                Text(title)
                    .fontWeight(.bold)
                Spacer()
                DatePicker("", selection: $date, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .tint(.colorPrimary)
                    .disabled(disabled)
            }
            .padding(.vertical, 10)
            .opacity(disabled ? 0.5 : 1.0)
            .overlay(disabled ? Color.white.opacity(0.001) : Color.clear) // Prevents interaction when disabled
        }
    }
}

struct CustomToggleStyle: ToggleStyle {
    var color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Rectangle()
                .foregroundColor(configuration.isOn ? color : .gray)
                .frame(width: 51, height: 31, alignment: .center)
                .overlay(
                    Circle()
                        .foregroundColor(.white)
                        .padding(3)
                        .offset(x: configuration.isOn ? 10 : -10)
                        .animation(.easeInOut(duration: 0.2))
                )
                .cornerRadius(20)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}
