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
    
    init(name: String, budget: Int, icon: String, isEnable: Bool) {
        self.name = name
        self.budget = budget
        self.icon = icon
        self.isEnable = isEnable
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
    
    static var foodCategory: Category =         Category(name: .food,
                                                         budget: 1000000,
                                                         icon: "fork.knife",
                                                         isEnable: true)
    
    static var categories: [Category] = [
        Category(name: .food,
                  budget: 1000000,
                  icon: "fork.knife",
                  isEnable: true),
        
        Category(name: .transport,
                  budget: 200000,
                  icon: "car.fill",
                  isEnable: true),
        
        Category(name: .health,
                  budget: 100000,
                  icon: "stethoscope",
                  isEnable: true),
        
        Category(name: .shopping,
                  budget: 100000,
                  icon: "cart.fill",
                  isEnable: true),
        
        Category(name: .travelling,
                  budget: 100000,
                  icon: "airplane.departure",
                  isEnable: true),
        
        Category(name: .education,
                  budget: 100000,
                  icon: "graduationcap.fill",
                  isEnable: true),
        
        Category(name: .pet,
                  budget: 100000,
                  icon: "pawprint.fill",
                  isEnable: true),
        
        Category(name: .utilities,
                  budget: 100000,
                  icon: "wrench.adjustable.fill",
                  isEnable: true),
        
        Category(name: .hobby,
                  budget: 100000,
                  icon: "gamecontroller.fill",
                  isEnable: true),
        
        Category(name: .others,
                  budget: 100000,
                  icon: "list.bullet",
                  isEnable: true),
    ]
    
    static func insertSampleData(modelContext: ModelContext) {
        // Add the expense to the model context.
        for category in categories {
            modelContext.insert(category)
        }
    }
}
