//
//  ExpenseListView.swift
//  iTrack
//
//  Created by Diki Dwi Diro on 25/06/24.
//

import SwiftUI
import SwiftData

struct ExpenseListView: View {
    @Environment(\.dismiss) var dismiss
    let expenses: [Expense]
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(expenses) { expense in
                    ExpenseRowView(expense: expense, isShowIcon: true)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Expense List")
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
    }
}


#Preview("ExpenseListView") {
    ModelContainerPreview(ModelContainer.sample) {
        NavigationStack {
            ExpenseListView(expenses: Expense.dummyExpenses)
        }
    }
}
