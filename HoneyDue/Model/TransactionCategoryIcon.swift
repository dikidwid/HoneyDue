//
//  TransactionCategoryIcon.swift
//  HoneyDue
//
//  Created by Arya Adyatma on 21/06/24.
//

import Foundation
import SwiftUI

struct TransactionCategoryIcon {
    let bgColor: Color
    let sfSymbol: String
    
    static func fromCategoryString(categoryString: String) -> TransactionCategoryIcon {
        // The AI determines category by string.
        // We will use this function to get the category image based on the string predicted by GPT.
        switch categoryString {
        case "food_and_beverage":
            return TransactionCategoryIcon(bgColor: .colorCategoryFoodAndBeverage, sfSymbol: "fork.knife")
        case "transportation":
            return TransactionCategoryIcon(bgColor: .colorCategoryTransportation, sfSymbol: "car.fill")
        case "shopping":
            return TransactionCategoryIcon(bgColor: .colorCategoryShopping, sfSymbol: "handbag.fill")
        case "travelling":
            return TransactionCategoryIcon(bgColor: .colorCategoryTravelling, sfSymbol: "airplane.departure")
        case "pet":
            return TransactionCategoryIcon(bgColor: .colorCategoryPet, sfSymbol: "pawprint.fill")
        case "hobby":
            return TransactionCategoryIcon(bgColor: .colorCategoryHobby, sfSymbol: "figure.run")
            // TODO: Support user defined category
        default:
            return TransactionCategoryIcon(bgColor: .gray, sfSymbol: "")
        }
    }
    
}
