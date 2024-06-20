//
//  DummyData.swift
//  VisionAI
//
//  Created by Arya Adyatma on 19/06/24.
//

import Foundation

extension ScanExpenseResult {
    static func getExample() -> ScanExpenseResult {
        let items = [
            ScanExpenseItem(id: "1", name: "Iced Sweet Lychee Tea", pricePerQtyIDR: 25000, qty: 2, emoji: "🍹", notes: "", taxRate: 0.1),
            ScanExpenseItem(id: "2", name: "Choco Motive", pricePerQtyIDR: 10000, qty: 2, emoji: "🍫", notes: "", taxRate: 0.1),
            ScanExpenseItem(id: "3", name: "Red", pricePerQtyIDR: 15000, qty: 2, emoji: "🍷", notes: "", taxRate: 0.1),
            ScanExpenseItem(id: "4", name: "Black", pricePerQtyIDR: 12000, qty: 1, emoji: "☕️", notes: "", taxRate: 0.1)
        ]
        return ScanExpenseResult(
            id: "example1",
            items: items,
            taxChargeIDR: 11200,
            serviceChargeIDR: 5000,
            othersChargeIDR: 0,
            discountsIDR: 0
        )
    }
}
