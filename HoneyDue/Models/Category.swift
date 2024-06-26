//
//  Category.swift
//  iTrack
//
//  Created by Diki Dwi Diro on 20/06/24.
//

import SwiftUI
import SwiftData

@Model
class Category {
    var name: String
    @Relationship(deleteRule: .cascade, inverse: \Expense.category)
    var expenses: [Expense] = []
    var budget: Int
    var icon: String
    var isEnable: Bool
    var item: Item 
    
    init(name: String, budget: Int, icon: String, isEnable: Bool, item: Item) {
        self.name = name
        self.budget = budget
        self.icon = icon
        self.isEnable = isEnable
        self.item = item
    }
}


// MARK: -- Category Extension for predefined categories
extension Category {
    var color: Color {
        switch self.name {
        case .food:
            return .foodColor
        case .transport:
            return .transportColor
        case .health:
            return .healthColor
        case .shopping:
            return .shoppingColor
        case .travelling:
            return .travellingColor
        case .education:
            return .educationColor
        case .pet:
            return .petColor
        case .utilities:
            return .utilitiesColor
        case .hobby:
            return .hobbyColor
        case .others:
            return .othersAndOverallColor
        default:
            return .clear
        }
    }
    
    static var categories: [Category] = [
        Category(name: .food,
                  budget: 1000000,
                  icon: "fork.knife",
                 isEnable: true, 
                 item: .foodItem),
        
        Category(name: .transport,
                  budget: 200000,
                  icon: "car.fill",
                 isEnable: true, item: .transportItem),
        
        Category(name: .health,
                  budget: 100000,
                  icon: "stethoscope",
                 isEnable: true, item: .healthItem),
        
        Category(name: .shopping,
                  budget: 100000,
                  icon: "cart.fill",
                 isEnable: true, item: .clothesItem),
        
        Category(name: .travelling,
                  budget: 100000,
                  icon: "airplane.departure",
                 isEnable: true, item: .travelItem),
        
        Category(name: .education,
                  budget: 100000,
                  icon: "graduationcap.fill",
                 isEnable: true, item: .workItem),
        
        Category(name: .pet,
                  budget: 100000,
                  icon: "pawprint.fill",
                 isEnable: true,
                 item: .petItem),
        
        Category(name: .utilities,
                  budget: 100000,
                  icon: "wrench.adjustable.fill",
                 isEnable: true, item: .utilitiesItem),
        
        Category(name: .hobby,
                  budget: 100000,
                  icon: "gamecontroller.fill",
                 isEnable: true, item: .entertainmentItem),
        
        Category(name: .others,
                  budget: 100000,
                  icon: "list.bullet",
                 isEnable: true, item: .othersItem),
    ]
    
    static func insertSampleData(modelContext: ModelContext) {
        // Add the expense to the model context.
        for category in categories {
            modelContext.insert(category)
        }
    }
    
}


// MARK: -- Category Extension for easy to calculate the category
extension Category {
    var totalExpense: Int {
        return expenses.map { $0.amount }.reduce(0, +)
    }
    
    var remainingBudget: Int {
        return budget - totalExpense
    }
    
    var remainingBudgetPercentage: Double {
        return 1.0 - ( Double(totalExpense) / Double(budget))
    }
    
    var status: String {
        if remainingBudgetPercentage >= 0 && remainingBudgetPercentage <= 0.3 {
            return "Warning!"
        } else if remainingBudgetPercentage > 0.3 && remainingBudgetPercentage <= 0.6 {
            return "Still Safe"
        } else if remainingBudgetPercentage > 0.6 && remainingBudgetPercentage <= 1.0 {
            return "On Track"
        } else {
            return "Exceed!!!"
        }
    }
}
