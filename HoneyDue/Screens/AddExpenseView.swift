//
//  AddExpenseView.swift
//  iTrack
//
//  Created by Diki Dwi Diro on 25/06/24.
//

import SwiftUI

struct AddExpenseView: View {
    @Environment(\.modelContext) var modelContext
    
    @State var name: String = ""
    @State var amount: Int = 0
    @State var date: Date = .now
    @State var selectedCategory: Category
    
    @FocusState var isAmountFieldFocused: Bool
    @FocusState var isExpenseNameFieldFocused: Bool
    @FocusState var isNoteFieldFocused: Bool
    
    let category: Category
    let dismiss: DismissAction
    
    init(category: Category, dismiss: DismissAction) {
        self.category = category
        self.dismiss = dismiss
        self.selectedCategory = category
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(spacing: 5) {
                    Text("Expense Amount")
                        .font(.system(.caption, weight: .medium))
                        .foregroundStyle(isAmountFieldFocused ? Color.appPrimary : .secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    CurrencyField(value: $amount, isCurrencyFieldFocused: isAmountFieldFocused)
                        .font(.system(.largeTitle, weight: .heavy))
                        .foregroundStyle(amount == 0 ? .secondary : .primary)
                        .foregroundStyle(isAmountFieldFocused && amount > 0 ? Color.appPrimary : .primary)
                        .focused($isAmountFieldFocused)
                        .tint(.appPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                }
                
                CustomTextFieldView(title: "Expense Name", placeholder: "Your expense name", value: $name, isFieldFocused: $isExpenseNameFieldFocused)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            
                            Button("Done") {
                                isExpenseNameFieldFocused = false
                            }
                            .bold()
                        }
                    }
                
                HStack {
                    Text("Category")
                        .font(.system(.body, weight: .medium))
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(Category.categories) { category in
                            HStack(spacing: 30) {
                                Image(systemName: category.icon)
                                Text(category.name)
                            }
                            .tag(category as Category)
                        }
                    }
                }

                HStack {
                    Text("Date")
                        .font(.system(.body, weight: .medium))
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    DatePicker("", selection: $date, displayedComponents: .date)
                        .datePickerStyle(.compact)
                }
                .padding(.bottom, 5)
                
                Button {
                    saveExpense()
                } label: {
                    CustomButtonView(title: "Save")
                }
            }
            .navigationTitle("Add New Expense")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal)
            .onAppear {
                self.selectedCategory = category
            }
        }
    }
    
    func saveExpense() {
        let expense: Expense = Expense(name: name,
                                       amount: amount,
                                       category: selectedCategory,
                                       date: date)
        
        modelContext.insert(expense)
        
        dismiss()
    }
}

#Preview {
}
