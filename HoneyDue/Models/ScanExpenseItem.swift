//
//  TransactionItem.swift
//  VisionAI
//
//  Created by Arya Adyatma on 12/06/24.
//

import Foundation

struct ScanExpenseItem : Hashable, Codable, Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var pricePerQtyIDR: Double
    var qty: Double
    var emoji: String
    var notes: String
    var taxRate: Double = 0.0
    var isSelected: Bool = true
    var categoryString: String = ""
    
    init(name: String, pricePerQtyIDR: Double, qty: Double, emoji: String, notes: String, categoryString: String) {
        self.name = name
        self.pricePerQtyIDR = pricePerQtyIDR
        self.qty = qty
        self.emoji = emoji
        self.notes = notes
        self.categoryString = categoryString
    }
    
    mutating func setTaxRate(taxRate: Double) {
        self.taxRate = taxRate
    }
    
    func getPricePerQtyIDR(includeTax: Bool) -> Double {
        let price = includeTax ? pricePerQtyIDR * (1 + taxRate) : pricePerQtyIDR
        return price
    }
    
    func getPriceTimesQtyIDR(includeTax: Bool) -> Double {
        let price = pricePerQtyIDR * qty
        return includeTax ? price * (1 + taxRate) : price
    }
    
    func toExpenseItem() -> Void {
        // TODO: Convert to ExpenseItem includes taxRate.
    }
    
    func getCategory() -> Category {
        return Category.categories.first(where: { item in item.name == categoryString }) ?? Category.categories.last!
//        return TransactionCategory.categories.first(where: { item in item.name == categoryString }) ?? TransactionCategory.categories[0]
    }
    
    static func fromJsonArray(jsonString: String) -> [ScanExpenseItem] {
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                let expenseItems = try JSONDecoder().decode([ScanExpenseItem].self, from: jsonData)
                return expenseItems
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        } else {
            print("Failed to convert JSON string to Data")
        }
        return []
    }
}
