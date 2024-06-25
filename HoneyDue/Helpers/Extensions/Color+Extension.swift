//
//  Color+Extension.swift
//  minichallenge2
//
//  Created by Benedick Wijayaputra on 24/06/24.
//

import SwiftUI

extension Color {
    static let appPrimary            = Color(hex: "FFA13F")
    static let darkerPrimaryColor    = Color(hex: "D07723")
    static let secondaryColor        = Color(hex: "4169E1")
    static let accentColor           = Color(hex: "FFD700")
    
    static let primaryBackground     = Color(hex: "FEFEFE")
    static let secondaryBackground   = Color(hex: "F3F2F7")
    
    static let notifiBackground      = Color(hex: "EEEEEE")
    static let failBackground        = Color(hex: "F7B6B6")
    static let failForeground        = Color(hex: "DC143C")
    static let successBackground     = Color(hex: "E6FDE6")
    static let successForeground     = Color(hex: "7CBE7C")
    
    static let primaryTextColor      = Color(hex: "333333")
    static let secondaryTextColor    = Color(hex: "666666")
    static let placeholderTextColor  = Color(hex: "999999")
    
    static let othersAndOverallColor = Color(hex: "778899")
    static let petColor              = Color(hex: "87CEEB")
    static let hobbyColor            = Color(hex: "66D2AE")
    static let healthColor           = Color(hex: "20B2AA")
    static let transportColor        = Color(hex: "558A8C")
    static let foodColor             = Color(hex: "B39EB5")
    static let utilitiesColor        = Color(hex: "CDC683")
    static let travellingColor       = Color(hex: "F0C8A3")
    static let educationColor        = Color(hex: "FFA07A")
    static let shoppingColor         = Color(hex: "D07171")
    
    static let greenProgressColor    = Color(hex: "90EE90")
    static let orangeProgressColor   = Color(hex: "FF7F50")
    static let redProgressColor      = Color(hex: "CD5C5C")
}

// Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
