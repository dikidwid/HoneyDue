//
//  ExpenseRowView.swift
//  iTrack
//
//  Created by Diki Dwi Diro on 25/06/24.
//

import SwiftUI

struct ExpenseRowView: View {
    let expense: Expense
    let isShowIcon: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.background)
            .shadow(color: .black.opacity(0.1), radius: 5)
            .overlay(alignment: .leading) {
                HStack {
                    if isShowIcon {
                        Circle()
                            .fill(expense.category.color)
                            .overlay {
                                Image(systemName: expense.category.icon)
                                    .font(.title2)
                                    .foregroundStyle(.white)
                            }
                            .padding([.vertical, .trailing], 5)
                    }
                    VStack(alignment: .leading, spacing: 7.5) {
                        Text(expense.name)
                            .font(.system(.subheadline, weight: .medium))
                        
                        Text(expense.date.formatted(date: .long, time: .shortened))
                            .font(.system(.caption))
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Text(expense.amount, format: .currency(code: "IDR"))
                        .font(.system(.body, weight: .semibold))
                }
                .padding(.horizontal)
            }
            .frame(height: 60)
    }
}

#Preview {
    ExpenseRowView(expense: .dummyExpenses[0], isShowIcon: false)
}
