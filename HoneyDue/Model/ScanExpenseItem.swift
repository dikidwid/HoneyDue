//
//  TransactionItem.swift
//  VisionAI
//
//  Created by Arya Adyatma on 12/06/24.
//

import Foundation

struct ScanExpenseItem : Hashable, Codable, Identifiable {
    var id: String
    var name: String
    var pricePerQtyIDR: Double
    var qty: Double
    var emoji: String
    var notes: String
    var taxRate: Double
    var isSelected: Bool = true
    
    func getPricePerQtyIDR(includeTax: Bool) -> Double {
        let price = includeTax ? pricePerQtyIDR * (1 + taxRate) : pricePerQtyIDR
        return price
    }
    
    func getPriceTimesQtyIDR(includeTax: Bool) -> Double {
        let price = pricePerQtyIDR * qty
        return includeTax ? price * (1 + taxRate) : price
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
