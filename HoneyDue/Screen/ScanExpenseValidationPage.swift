//
//  ScanBillResults.swift
//  VisionAI
//
//  Created by Arya Adyatma on 12/06/24.
//

import SwiftUI

struct ScanExpenseValidationPage: View {
    @State var expenseResult: ScanExpenseResult = ScanExpenseResult.getExample()
    @State private var isEditing: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Scan Bill Results")
                    .font(.title)
                    .fontWeight(.bold)
                Text("This is the scanned result. Make sure to check that the items were scanned correctly.")
                    .fontWeight(.medium)
                    .opacity(0.3)
                
                Group {
                    VStack(spacing: 16) {
                        ForEach(expenseResult.items.indices, id: \.self) { index in
                            ExpenseItemView(item: $expenseResult.items[index], isEditing: $isEditing)
                        }
                    }
                    .padding(.vertical)
                }
                .background(.white)
                .cornerRadius(16)
                .padding(.top)
                
//                HStack {
//                    Text("You scanned bill includes tax amount. We adjusted your item price to match after tax.")
//                        .font(.callout)
//                        .foregroundStyle(.green)
//                        .fontWeight(.semibold)
//                        .padding()
//                    Spacer()
//                }
//                .background(.green.opacity(0.2))
//                .cornerRadius(16)
                
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
                .padding(.top)
                
                HStack {
                    Spacer()
                    Button(action: {
                        isEditing.toggle()
                    }) {
                        Text(isEditing ? "Finish Edit Bill" : "Edit Bill")
                    }
                }
                
                Button(action: {
                    // Action here
                }) {
                    Text("Confirm Bill")
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(16)
                }
                .background(Color(UIColor.systemGray6))
                .edgesIgnoringSafeArea(.all)
                .padding(.top)
                
                Spacer()
            }
            .padding()
        }
        .background(Color.black.opacity(0.05).edgesIgnoringSafeArea(.all))
    }
}
struct ExpenseItemView: View {
    @Binding var item: ScanExpenseItem
    @Binding var isEditing: Bool
    
    var body: some View {
        HStack {
            ZStack {
                Rectangle()
                    .foregroundStyle(.blue)
                    .opacity(0.2)
                    .frame(width: 48, height: 48)
                    .cornerRadius(16)
                Text(item.emoji)
                    .scaleEffect(1.5)
            }
            .padding(.leading)
            .padding(.trailing, 5)
            
            VStack(alignment: .leading) {
                if isEditing {
                    TextField("Name", text: $item.name)
                        .fontWeight(.bold)
                        .opacity(0.9)
                        .textFieldStyle(BlueUnderlineTextFieldStyle())
                } else {
                    Text(item.name)
                        .fontWeight(.bold)
                        .opacity(0.9)
                }
                
                HStack {
                    if isEditing {
                        TextField("Price", value: $item.pricePerQtyIDR, format: .number)
                            .opacity(0.6)
                            .textFieldStyle(BlueUnderlineTextFieldStyle())
                    } else {
                        Text(item.getPricePerQtyIDR(includeTax: false).toIDRString())
                            .opacity(0.6)
                    }
                    Spacer()
                    if isEditing {
                        TextField("Quantity", value: $item.qty, format: .number)
                            .opacity(0.6)
                            .textFieldStyle(BlueUnderlineTextFieldStyle())
                            .frame(width: 50)
                    } else {
                        Text("x\(Int(item.qty))")
                            .opacity(0.6)
                    }
                    Spacer()
                    Text(item.getPriceTimesQtyIDR(includeTax: false).toIDRString())
                        .fontWeight(.bold)
                }
            }
            .padding(.trailing)
        }
    }
}

struct BlueUnderlineTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.bottom, 2)
            .overlay(Rectangle().frame(height: 1).foregroundColor(.blue), alignment: .bottom)
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
                Spacer()
                if isEditing {
                    TextField("Price", value: $priceText, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .textFieldStyle(BlueUnderlineTextFieldStyle())
                        .frame(width: 80)
                } else {
                    Text(priceText, format: .number)
                        .fontWeight(.bold)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
        }
    }
}

#Preview {
    ScanExpenseValidationPage()
}
