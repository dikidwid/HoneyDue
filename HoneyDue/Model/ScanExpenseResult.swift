//
//  ScanBillResults.swift
//  VisionAI
//
//  Created by Arya Adyatma on 16/06/24.
//

import Foundation

struct ScanExpenseResult : Hashable, Codable, Identifiable {
    
    let id: String
    var items: [ScanExpenseItem]
    var taxChargeIDR: Double
    var serviceChargeIDR: Double
    var othersChargeIDR: Double
    var discountsIDR: Double
    var subtotalIDR: Double = 0
    var totalIDR: Double = 0
    
    init(id: String, items: [ScanExpenseItem], taxChargeIDR: Double, serviceChargeIDR: Double, othersChargeIDR: Double, discountsIDR: Double) {
        self.id = id
        self.items = items
        self.taxChargeIDR = taxChargeIDR
        self.serviceChargeIDR = serviceChargeIDR
        self.othersChargeIDR = othersChargeIDR
        self.discountsIDR = discountsIDR
        self.subtotalIDR = getSubtotalIDR(includeTax: false)
        self.totalIDR = getTotalIDR()
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
    
}
