//
//  TransactionCategory.swift
//  HoneyDue
//
//  Created by Arya Adyatma on 21/06/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class TransactionCategory {
    var name: String
    var budget: Double
    var icon: String
    var isEnable: Bool
    
    init(name: String, budget: Double, icon: String, isEnable: Bool) {
        self.name = name
        self.budget = budget
        self.icon = icon
        self.isEnable = isEnable
    }
    
    func getColor() -> Color {
        switch self.name {
        case "Food & Beverage":
            return .red
        case "Transport":
            return .blue
        case "Shopping":
            return .yellow
        case "Entertainment":
            return .purple
        case "Health":
            return .green
        default:
            return .clear
        }
    }
}

extension TransactionCategory {
    static var categories: [TransactionCategory] = [
        TransactionCategory(name: "Food & Beverage",
                  budget: 1000000,
                  icon: "fork.knife",
                  isEnable: true),
        
        TransactionCategory(name: "Transport",
                  budget: 200000,
                  icon: "car.fill",
                  isEnable: true),
        
        TransactionCategory(name: "Shopping",
                  budget: 100000,
                  icon: "cart.fill",
                  isEnable: true),
        
        TransactionCategory(name: "Entertainment",
                  budget: 100000,
                  icon: "theatermasks.fill",
                  isEnable: true),
        
        TransactionCategory(name: "Health",
                  budget: 100000,
                  icon: "stethoscope",
                  isEnable: true)
    ]
    
    static func insertSampleData(modelContext: ModelContext) {
        // Add the expense to the model context.
        for category in categories {
            modelContext.insert(category)
        }
    }
    
    static func getColor(for category: TransactionCategory) -> Color {
        switch category.name {
        case "Food & Beverage":
            return .red
        case "Transport":
            return .blue
        case "Shopping":
            return .yellow
        case "Entertainment":
            return .purple
        case "Health":
            return .green
        default:
            return .clear
        }
    }
}
