//
//  ExpenseDetailView.swift
//  iTrack
//
//  Created by Diki Dwi Diro on 20/06/24.
//

import SwiftUI
import SwiftData

struct ExpenseDetailView: View {
    @State private var isShowAllExpenseList: Bool = false
    @Binding var isShowAddExpenseView: Bool
    
    @Environment(\.dismiss) var dismiss
    @Query private var expenses: [Expense]

    let category: Category
    @State var progressBarValue: Double = 1

    init(category: Category, isShowAddExpense: Binding<Bool>) {
        self.category = category
        _expenses = Query(filter: Expense.predicate(categoryName: category.name),
                          sort: \Expense.date,
                          order: .forward)
        
        self._isShowAddExpenseView = isShowAddExpense
    }
        
    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .top) {
                    Image(systemName: category.icon)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.all, 12)
                        .background(Circle().fill(category.color))
                        .padding(.trailing, 5)
                    
                    VStack(alignment: .leading) {
                        Text(category.name)
                            .font(.system(.title2, weight: .bold))
                        
                        Group {
                            Text(category.budget, format: .currency(code: "IDR"))
                                .font(.system(.body, weight: .medium))
                                .foregroundStyle(.secondary)

                        }
                    }
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.bottom)
                
                if !expenses.isEmpty {
                    ProgressBarView(progress: progressBarValue)
                        .frame(height: 28)
                        .padding(.bottom, 2.5)
                    
                    Group {
                        Text("You have ")
                        
                        +
                        
                        Text("Rp. \(getBudgetRemaining())")
                            .font(.system(.headline, weight: .bold))
                            .foregroundStyle(Color.appPrimary)
                        
                        +
                        
                        Text(" budget left")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(.callout, weight: .regular))
                    .foregroundStyle(.secondary)
                    
                    .padding(.bottom, 20)
                    
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Text("Recent Transactions")
                                .font(.system(.title3, weight: .semibold))
                            
                            Spacer()
                            
                            Button {
                                isShowAllExpenseList.toggle()
                            } label: {
                                Text("View all")
                                    .font(.system(.headline))
                                    .underline()
                                    .tint(.appPrimary)
                                    .padding(.trailing)
                            }
                            
                        }
                        .padding(.bottom, 10)
                        
                        ForEach(Array(expenses.prefix(3))) { expense in
                            ExpenseRowView(expense: expense, isShowIcon: false)
                        }
                    }
                    .padding(.bottom)
                    
                    Spacer()
                } else {
                    ContentUnavailableView(label: {
                        Label("No Expenses", systemImage: "list.bullet.rectangle.portrait")
                    }, description: {
                        Text("Start adding your expenses to see your list.")
                            .foregroundStyle(.secondary)
                    })
                    .foregroundStyle(.black, Color.appPrimary)
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        isShowAddExpenseView.toggle()
                    }
                } label: {
                    CustomButtonView(title: "Add Expense")
                }
            }
            .sheet(isPresented: $isShowAllExpenseList) {
                ExpenseListView(expenses: expenses)
            }
            .sheet(isPresented: $isShowAddExpenseView) {
                AddExpenseView(category: category, dismiss: dismiss)
                        .presentationDragIndicator(.visible)
                        .presentationCornerRadius(.modalityCornerRadius)
                        .presentationDetents([.fraction(0.525)])
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.all, 16)
            .padding(.top)
            .onAppear {
                updateProgressBar()
            }
        }
        .tint(.appPrimary)

    }
    
    func updateProgressBar() {
        let budget = Double(category.budget)
        let totalAmount = Double(getTotalExpensesAmount())
        
        let remainingPercentage = (1.0 - (totalAmount / budget))
        progressBarValue = remainingPercentage

        print(progressBarValue)

    }
    
    func getBudgetRemaining() -> Int {
        let totalExpensesAmount = getTotalExpensesAmount()
        return category.budget - totalExpensesAmount
    }
    
    func getTotalExpensesAmount() -> Int {
        let totalExpensesAmount = expenses.map { $0.amount }.reduce(.zero, +)
        return totalExpensesAmount
    }
}

#Preview("ExpenseDetailView") {
    ModelContainerPreview(ModelContainer.sample) {
        ExpenseDetailView(category: Category.categories[0], isShowAddExpense: .constant(false))
    }
}
