//
//  ExpenseListView.swift
//  iTrack
//
//  Created by Diki Dwi Diro on 25/06/24.
//

import SwiftUI
import SwiftData

struct ExpenseListView: View {
    let expenses: [Expense]
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(expenses) { expense in
                    ExpenseRowView(expense: expense, isShowIcon: false)
                }
                
                Spacer()
            }
            .navigationTitle(expenses[0].category.name)
            .padding()
        }
    }
}


#Preview("ExpenseListView") {
//    ModelContainerPreview(ModelContainer.sample) {
        NavigationStack {
            ExpenseListView(expenses: Expense.dummyExpenses)
//        }
    }
}
