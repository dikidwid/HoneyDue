//
//  ScanBillResults.swift
//  VisionAI
//
//  Created by Arya Adyatma on 16/06/24.
//

import Foundation

struct ScanExpenseResult : Hashable, Codable, Identifiable {
    var id: String = UUID().uuidString
    var items: [ScanExpenseItem]
    var taxChargeIDR: Double
    var serviceChargeIDR: Double
    var othersChargeIDR: Double
    var discountsIDR: Double
    var subtotalIDR: Double = 0
    var totalIDR: Double = 0
    
    init(items: [ScanExpenseItem], taxChargeIDR: Double, serviceChargeIDR: Double, othersChargeIDR: Double, discountsIDR: Double) {
        self.items = items
        self.taxChargeIDR = taxChargeIDR
        self.serviceChargeIDR = serviceChargeIDR
        self.othersChargeIDR = othersChargeIDR
        self.discountsIDR = discountsIDR
        self.subtotalIDR = getSubtotalIDR(includeTax: false)
        self.totalIDR = getTotalIDR()
    }
    
    func getItemsAsExpense() -> [Expense] {
        var expenses: [Expense] = []
        for item in items {
            let exp = Expense(
                name: item.name,
                amount: Int(item.getPriceTimesQtyIDR(includeTax: true)),
                category: item.getCategory(),
                date: Date()
            )
            expenses.append(exp)
        }
        return expenses
    }
    
    func getSubtotalIDR(includeTax: Bool) -> Double {
        var subtotal = 0.0
        for item in items {
            subtotal += item.getPriceTimesQtyIDR(includeTax: includeTax)
        }
        return subtotal
    }
    
    func getTotalIDR() -> Double {
        let subtotal = getSubtotalIDR(includeTax: false)
        let total = subtotal + taxChargeIDR + serviceChargeIDR + othersChargeIDR - discountsIDR
        return total
    }
    
    mutating func adjustTax() {
        let taxRate: Double = (taxChargeIDR + serviceChargeIDR + othersChargeIDR) / getSubtotalIDR(includeTax: false)
        
        for index in items.indices {
            items[index].setTaxRate(taxRate: taxRate)
        }
    }
    
    static func fromJsonAuto(jsonString: String) -> ScanExpenseResult? {
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                let result = try JSONDecoder().decode(ScanExpenseResult.self, from: jsonData)
                return result
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        } else {
            print("Failed to convert JSON string to Data")
        }
        return nil
    }
    
    static func fromJson(jsonString: String) -> ScanExpenseResult? {
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    var items: [ScanExpenseItem] = []
                    if let itemsArray = jsonDict["items"] as? [[String: Any]] {
                        for itemDict in itemsArray {
                            let item = ScanExpenseItem(
                                name: itemDict["name"] as? String ?? "",
                                pricePerQtyIDR: itemDict["pricePerQtyIDR"] as? Double ?? 0.0,
                                qty: itemDict["qty"] as? Double ?? 0.0,
                                emoji: itemDict["emoji"] as? String ?? "",
                                notes: itemDict["notes"] as? String ?? "",
                                categoryString: itemDict["categoryString"] as? String ?? ""
                            )
                            items.append(item)
                        }
                    }
                    let result = ScanExpenseResult(
                        items: items,
                        taxChargeIDR: jsonDict["taxChargeIDR"] as? Double ?? 0.0,
                        serviceChargeIDR: jsonDict["serviceChargeIDR"] as? Double ?? 0.0,
                        othersChargeIDR: jsonDict["othersChargeIDR"] as? Double ?? 0.0,
                        discountsIDR: jsonDict["discountsIDR"] as? Double ?? 0.0
                    )
//                    print(result)
                    return result
                }
            } catch {
                print("Failed to parse JSON: \(error.localizedDescription)")
            }
        } else {
            print("Failed to convert JSON string to Data")
        }
        return nil
    }
}
