//
//  ScanExpenseSelectTransactionPage.swift
//  HoneyDue
//
//  Created by Arya Adyatma on 21/06/24.
//

import SwiftUI

struct ScanExpenseSelectTransactionPage: View {
    @ObservedObject var viewModel = ScanExpenseViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Text("Your Receipt")
                        .font(.title)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding(.bottom, 5)
                Text("Choose the item and the amount you want to add to your expense. You can also edit the category here.")
                    .fontWeight(.medium)
                    .opacity(0.3)
                
                Group {
                    VStack(spacing: 16) {
                        ForEach(viewModel.expenseResult.items.indices, id: \.self) { index in
                            ExpenseTransactionItemView(
                                item: $viewModel.expenseResult.items[index],
                                isChecked: $viewModel.expenseResult.items[index].isSelected
                            )
                            Rectangle()
                                .frame(height: 1)
                                .opacity(0.1)
                        }
                    }
                    .padding(.vertical)
                }
                .padding(.top, 2)
                
                
                HStack {
                    Checkbox(isChecked: $viewModel.isSelectAll)
                    Text("Select All")
                        .foregroundColor(.primary)
                }
                
                Button(action: {
                    // Action here
                }) {
                    Text("Save")
                        .fontWeight(.medium)
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

struct ExpenseTransactionItemView: View {
    @Binding var item: ScanExpenseItem
    @Binding var isChecked: Bool
    let showIcon: Bool = true
    let isEditing: Bool = true
    
    // Add a state variable to control the presentation of the bottom sheet
    @State private var showBottomSheet: Bool = false
    
    var body: some View {
        let itemIcon = TransactionCategoryIcon.fromCategoryString(categoryString: item.categoryString)
        
        HStack {
            if showIcon {
                ZStack {
                    Circle()
                        .foregroundStyle(itemIcon.bgColor)
                        .opacity(1)
                        .frame(width: 48, height: 48)
                    Image(systemName: itemIcon.sfSymbol)
                        .foregroundStyle(.white)
                        .scaleEffect(1.2)
                }
                .padding(.trailing, 5)
                // Add a tap gesture to the icon
                .onTapGesture {
                    showBottomSheet = true
                }
                // Add a bottom sheet that is presented when the icon is tapped
                .sheet(isPresented: $showBottomSheet) {
                    VStack {
                        Text("Hello")
                        Spacer()
                    }
                    .presentationDetents([.height(300), .medium, .large])
                    .presentationDragIndicator(.automatic)
                    .padding()
                }
            }
            
            VStack(alignment: .leading) {

                Text(item.name)
                    .fontWeight(.bold)
                    .opacity(0.9)
                
                
                HStack {
                    Text(item.getPricePerQtyIDR(includeTax: false).toIDRString())
                        .opacity(0.6)
                
                    Spacer()
                    if isEditing && item.qty != 1 {
                        TextField("Quantity", value: $item.qty, format: .number)
                            .opacity(0.6)
                            .textFieldStyle(CustomTextFieldStyle())
                            .frame(width: 32)
                    } else {
                        ZStack {
                            Text("x\(Int(item.qty))")
                                .opacity(0.6)
                            TextField("Quantity", value: $item.qty, format: .number)
                                .opacity(0.0)
                                .textFieldStyle(CustomTextFieldStyle())
                                .frame(width: 32)
                            
                        }

                    }
                    Spacer()
                    Text(item.getPriceTimesQtyIDR(includeTax: false).toIDRString())
                        .fontWeight(.bold)
                    Spacer()
                    Checkbox(isChecked: $isChecked)
                }
            }
        }
    }
}

struct Checkbox: View {
    @Binding var isChecked: Bool
    
    var body: some View {
        Button(action: {
            self.isChecked.toggle()
        }) {
            HStack {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .foregroundColor(isChecked ? .colorPrimary : .gray)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ScanExpenseSelectTransactionPage()
}
