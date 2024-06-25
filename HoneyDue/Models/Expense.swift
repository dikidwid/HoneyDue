//
//  Expense.swift
//  iTrack
//
//  Created by Diki Dwi Diro on 14/06/24.
//

import Foundation
import SwiftData

@Model
class Expense {
    var name: String
    var amount: Int
    var category: Category
    var date: Date
    
    init(name: String, amount: Int, category: Category, date: Date) {
        self.name = name
        self.amount = amount
        self.category = category
        self.date = date
    }
}

extension Expense {
    static func predicate(categoryName: String) -> Predicate<Expense> {
        return #Predicate<Expense> { $0.category.name == categoryName}
    }
}

//MARK: -- Extension for Preview

extension Expense {
    static let dummyExpenses: [Expense] = [
        Expense(name: "Kasturi",
                amount: 15000,
                category: .categories[0],
                date: .now),
        
        Expense(name: "Hachi grill",
                amount: 170000,
                category: .categories[0],
                date: .now),
        
        Expense(name: "Soto ayam",
                amount: 25000,
                category: .categories[0],
                date: .now),
        
        Expense(name: "Gojek",
                amount: 12000,
                category: .categories[1],
                date: .now),
        
        Expense(name: "Parfume",
                amount: 15000,
                category: .categories[3],
                date: .now)
    ]
    
    static func insertSampleData(modelContext: ModelContext) {
        // Add the expense to the model context.
        for dummyExpense in dummyExpenses {
            modelContext.insert(dummyExpense)
        }
    }
}
