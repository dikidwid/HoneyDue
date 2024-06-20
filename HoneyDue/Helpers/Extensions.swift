//
//  Extensions.swift
//  VisionAI
//
//  Created by Arya Adyatma on 19/06/24.
//

import Foundation

extension Double {
    func toIDRString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "Rp"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self))?.replacing(" ", with: "") ?? ""
    }
}
