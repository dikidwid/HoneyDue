//
//  TransactionCategory.swift
//  HoneyDue
//
//  Created by Arya Adyatma on 21/06/24.
//

import Foundation
import SwiftUI
import SwiftData

enum CategoryName: String, CaseIterable {
    case food = "Food"
    case transport = "Transport"
    case health = "Health"
    case shopping = "Shopping"
    case travelling = "Travelling"
    case education = "Education"
    case pet = "Pet"
    case utilities = "Utilities"
    case hobby = "Hobby"
    case others = "Others"
}

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
        switch CategoryName(rawValue: self.name) {
        case .food:
            return .colorCategoryFoodAndBeverage
        case .transport:
            return .colorCategoryTransportation
        case .health:
            return .colorCategoryHealth
        case .shopping:
            return .colorCategoryShopping
        case .travelling:
            return .colorCategoryTravelling
        case .education:
            return .colorCategoryEducation
        case .pet:
            return .colorCategoryPet
        case .utilities:
            return .colorCategoryUtilities
        case .hobby:
            return .colorCategoryHobby
        case .others:
            return .colorCategoryOthers
        case .none:
            return .gray
        }
    }
}

extension TransactionCategory {
    static var categories: [TransactionCategory] = [
        TransactionCategory(
            name: CategoryName.food.rawValue,
            budget: 1000000,
            icon: "fork.knife",
            isEnable: true
        ),
        TransactionCategory(
            name: CategoryName.transport.rawValue,
            budget: 200000,
            icon: "car.fill",
            isEnable: true
        ),
        TransactionCategory(
            name: CategoryName.health.rawValue,
            budget: 100000,
            icon: "cross.case.fill",
            isEnable: true
        ),
        TransactionCategory(
            name: CategoryName.shopping.rawValue,
            budget: 100000,
            icon: "cart.fill",
            isEnable: true
        ),
        TransactionCategory(
            name: CategoryName.travelling.rawValue,
            budget: 100000,
            icon: "airplane.departure",
            isEnable: true
        ),
        TransactionCategory(
            name: CategoryName.education.rawValue,
            budget: 100000,
            icon: "graduationcap.fill",
            isEnable: true
        ),
        TransactionCategory(
            name: CategoryName.pet.rawValue,
            budget: 100000,
            icon: "pawprint.fill",
            isEnable: true
        ),
        TransactionCategory(
            name: CategoryName.utilities.rawValue,
            budget: 100000,
            icon: "wrench.fill",
            isEnable: true
        ),
        TransactionCategory(
            name: CategoryName.hobby.rawValue,
            budget: 100000,
            icon: "gamecontroller.fill",
            isEnable: true
        ),
        TransactionCategory(
            name: CategoryName.others.rawValue,
            budget: 100000,
            icon: "list.bullet",
            isEnable: true
        )
    ]
    
    static func getCategoryNames() -> String {
        let categoryNames = CategoryName.allCases.map { $0.rawValue }
        return categoryNames.joined(separator: ", ")
    }
    
//    static func insertSampleData(modelContext: ModelContext) {
//        // Add the expense to the model context.
//        for category in categories {
//            modelContext.insert(category)
//        }
//    }
    
}
