//
//  OverviewPageView.swift
//  minichallenge2
//
//  Created by Benedick Wijayaputra on 23/06/24.
//

import SwiftUI
import Charts
import SwiftData

struct OverviewPageView: View {
    @State private var currentDate: Date = .now
    @State private var isShowCategoryListView: Bool = false
    @State private var isShowExpenseListView: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var overviewViewModel: OverviewViewModel
    
    @ObservedObject var homeViewModel: HomeViewModel
        
    var balance: Int {
        return homeViewModel.categories.map { $0.remainingBudget }.reduce(.zero, +)
    }
    
    var totalBudget: Int {
        homeViewModel.categories.map { $0.budget }.reduce(.zero, +)
    }
    
    var totalSpending: Int {
        homeViewModel.categories.map { $0.totalExpense }.reduce(.zero, +)
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                ScrollView {
                    TimeFrameView(currentDate: $currentDate)
                        .padding(.bottom, 12)
                    
                    HeaderView(balance: balance, totalBudget: totalBudget, totalSpending: totalSpending)
                        .padding(.bottom, 12)
                    
                    VStack(spacing: 32) {
                        Label("Spending Allocation", systemImage: "chart.pie.fill")
                            .font(.system(.headline, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        
                        let totalExpense = homeViewModel.categories.reduce(0) { $0 + $1.totalExpense }
                        
                        if totalExpense > 0 {
                            DonutView(categories: homeViewModel.categories.filter{ $0.totalExpense > 0 }.map { $0.name },
                                      budgets: getTotalBudget(from: homeViewModel.categories),
                                      expenses: getTotalSpending(from: homeViewModel.categories))
                            .padding(.vertical, 10)
                        }
                        
                        VStack(spacing: 12) {
                            Text("Top Spending Category")
                                .font(.system(.footnote, weight: .semibold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            ForEach(homeViewModel.categories.sorted(by: { $0.totalExpense > $1.totalExpense }).prefix(3)) { category in
                                CategoryRowView(category: category)
                            }
                            
                            Button {
                                isShowCategoryListView.toggle()
                            } label: {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.white)
                                    .frame(height: 40)
                                    .overlay {
                                        HStack {
                                            Text("Show all categories")
                                                .font(.system(.caption))
                                                .fontWeight(.medium)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                        }
                                        .padding(.horizontal)
                                        .tint(.black)
                                    }
                                    .shadow(color: .black.opacity(0.1), radius: 10)
                                    .padding([.horizontal, .bottom])
                            }
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.bottom, 12)
                    
                    #warning("COMPARISON BELOM KELAR WOY")
                    
                    TransactionListView(isShowExpenseListView: $isShowExpenseListView, expenses: Array(getAllExpensesSortedByDate(from: homeViewModel.categories).prefix(3)))
                }
            }
            .scrollIndicators(.hidden)
            .padding()
            .background(Color(UIColor.systemGray6))
            .navigationTitle("Overview")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $isShowCategoryListView) {
                CategoryListView(categories: homeViewModel.categories)
                    .navigationBarBackButtonHidden()
            }
            .navigationDestination(isPresented: $isShowExpenseListView) {
                ExpenseListView(expenses: getAllExpensesSortedByDate(from: homeViewModel.categories))
                    .navigationBarBackButtonHidden()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(.black)
                            .frame(width: 17, height: 17)
                    }
                    .padding(.leading)
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    func getAllExpensesSortedByDate(from categories: [Category]) -> [Expense] {
        return categories
            .flatMap { $0.expenses } // Flatten the array of expenses
            .sorted(by: { $0.date > $1.date }) // Sort by date in descending order
    }
    
    func getTotalSpending(from categories: [Category]) -> [String: Double] {
        var categoryDictionary: [String: Double] = [:]
        for category in categories {
            categoryDictionary[category.name] = Double(category.totalExpense)
        }
        return categoryDictionary
    }
    
    func getTotalBudget(from categories: [Category]) -> [String: Double] {
        var categoryDictionary: [String: Double] = [:]
        for category in categories {
            categoryDictionary[category.name] = Double(category.budget)
        }
        return categoryDictionary
    }
}

struct HeaderView: View {
    let balance: Int
    let totalBudget: Int
    let totalSpending: Int
        
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack (alignment: .leading, spacing: 5) {
                    Label("Balance", systemImage: "creditcard.fill")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .opacity(1)
                    
                    Text(balance, format: .currency(code: "IDR"))
                        .font(.system(size: 25))
                        .fontWeight(.heavy)
                        .foregroundStyle(balance > 0 ? Color.successForeground : Color.failForeground)
                }
                .font(.headline)
                
                Spacer()
                
                Button {
                    // Download Chart
                } label: {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 32, height: 32)
                        .background(Color.appPrimary)
                        .cornerRadius(8)
                        .overlay {
                            Image(systemName: "square.and.arrow.down")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .frame(width: 19.80952, height: 19.5122)
                                .font(.system(.title2, weight: .bold))
                        }
                }
            }
            .padding(.bottom)
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Total Budget")
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    
                    Text(totalBudget, format: .currency(code: "IDR"))
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                }
                Spacer()
                VStack(alignment: .leading, spacing: 5) {
                    Text("Total Spending")
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)

                    Text(totalSpending, format: .currency(code: "IDR"))
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                }
            }
            .font(.subheadline)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct TimeFrameView: View {
    @Binding var currentDate: Date
    
    let months: [String] = Calendar.current.shortMonthSymbols
    
    var body: some View {
        HStack {
            Button {
                // Move to previous month
                moveToPreviousMonth()
            } label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.black)
                    .frame(width: 12, height: 12)
                    .font(.system(.title2, weight: .bold))
            }
            
            Spacer()
            
            Text(currentDate, style: .date)
                .font(.system(size: 16))
                .fontWeight(.semibold)
            
            Spacer()
            
            Button {
                // Move to next month
                moveToNextMonth()
            } label: {
                Image(systemName: "chevron.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.black)
                    .frame(width: 12, height: 12)
                    .font(.system(.title2, weight: .bold))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }
    
    private var currentMonthIndex: Int {
        Calendar.current.component(.month, from: currentDate) - 1
    }
    
    private var currentYear: Int {
        Calendar.current.component(.year, from: currentDate)
    }
    
    private var currentMonthName: String {
        months[currentMonthIndex]
    }
    
    private func moveToPreviousMonth() {
        var components = DateComponents()
        components.year = currentYear
        components.month = currentMonthIndex
        
        if currentMonthIndex > 0 {
            components.month = currentMonthIndex
        } else {
            components.month = 12
            components.year = currentYear - 1
        }
        
        if let newDate = Calendar.current.date(from: components) {
            currentDate = newDate
        }
    }
    
    private func moveToNextMonth() {
        var components = DateComponents()
        components.year = currentYear
        components.month = currentMonthIndex + 2
        
        if currentMonthIndex < 11 {
            components.month = currentMonthIndex + 2
        } else {
            components.month = 1
            components.year = currentYear + 1
        }
        
        if let newDate = Calendar.current.date(from: components) {
            currentDate = newDate
        }
    }
}

struct SpendingPerCategoryView: View {
    // Dummy data
    let categories = ["Food & Beverage", "Transportation", "Shopping"]
    let spending = [300000.0, 400000.0, 850000.0]
    let remaining = [1700000.0, 600000.0, 150000.0]
    let status = ["On track", "Still safe", "Warning"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Spending per Category")
                .font(.headline)
                .padding()
                
            
            ForEach(0..<categories.count, id: \.self) { index in
                HStack {
                    VStack(alignment: .leading) {
                        Text(categories[index])
                            .fontWeight(.semibold)
                        Text(status[index])
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Rp \(spending[index], specifier: "%.0f")")
                            .fontWeight(.semibold)
                        Text("Rp \(remaining[index], specifier: "%.0f") remains")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
            }
            
            
            Button(action: {})
            {
                Rectangle()
                    .frame(width: 329, height: 38)
                    .foregroundColor(.clear)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 2, y: 2)
                    .overlay{
                        HStack (spacing: 161){
                            Text("Show all categories")
                                .font(.subheadline)
                                .foregroundColor(.black)
                                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                            
                            Image(systemName: "chevron.right")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.black)
                                .frame(width: 12, height: 12)
                                .font(.system(.title2, weight: .bold))
                        }
                        
                    }
                
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            
        }
    }
}


struct TransactionListView: View {
    @Binding var isShowExpenseListView: Bool
    // Dummy data
    let expenses: [Expense]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Expense List", systemImage: "list.bullet")
                .font(.system(.headline, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)
            
            if expenses.isEmpty {
                ContentUnavailableView(label: {
                    Label("No Expenses", systemImage: "list.bullet.rectangle.portrait")
                }, description: {
                    Text("Start adding your expenses to see your list.")
                        .foregroundStyle(.secondary)
                })
                .foregroundStyle(.black, Color.appPrimary)
            } else {
                VStack(spacing: 12) {
                    ForEach(expenses) { expense in
                        ExpenseRowView(expense: expense, isShowIcon: true)
                    }
                }
            }
            
            if !expenses.isEmpty {
                Button {
                    isShowExpenseListView.toggle()
                } label: {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white)
                        .frame(height: 40)
                        .overlay {
                            HStack {
                                Text("Show all expenses")
                                    .font(.system(.caption))
                                    .fontWeight(.medium)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                            }
                            .padding(.horizontal)
                            .tint(.black)
                        }
                        .shadow(color: .black.opacity(0.1), radius: 10)
                }
                .padding(.top, 12)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}


public var backButton: some View {
    @Environment(\.dismiss) var dismiss
    return Button(action: {
        dismiss()
    }) {
        Image(systemName: "arrow.backward")
            .foregroundColor(.black)
            .frame(width: 17, height: 17)
    }
}


#Preview {
        OverviewPageView(homeViewModel: HomeViewModel(dataSource: CategoryDataSource.shared))
}
