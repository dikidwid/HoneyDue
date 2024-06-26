//
//  Accessory.swift
//  HoneyDue
//
//  Created by Singgih Tulus Makmud on 26/06/24.
//

import SwiftUI

class Accessory: Identifiable, Equatable {
    
    var image: Image
    var accessoryType: AccessoryType
    var accessoryName: String
    
    
    init(accessoryType: AccessoryType, accessoryName: String) {
        self.accessoryType = accessoryType
        self.accessoryName = accessoryName
        
        switch accessoryType {
                case .hair(let hairAccessory):
                    self.image = Image(hairAccessory.imageName)
                case .badge(let badgeAccessory):
                    self.image = Image(badgeAccessory.imageName)
                }
    }
    
    func getAccessoryType() -> String {
        var type: String = ""
        if case .hair = self.accessoryType{
            type = "hair"
        }
        else if case .badge = self.accessoryType{
            type = "badge"
        }
        return type
    }
    
    
    enum AccessoryType {
        case hair(HairAccessory)
        case badge(BadgeAccessory)
    }
    
    enum HairAccessory: String, CaseIterable {
        case hair1
        case hair2
        case hair3
        case hair4
        case hair5
        case hair6
        
        var imageName: String {
            switch self {
            case .hair1:
                return "hair1"
            case .hair2:
                return "hair2"
            case .hair3:
                return "hair3"
            case .hair4:
                return "hair4"
            case .hair5:
                return "hair5"
            case .hair6:
                return "hair6"
            }
        }
    }

    enum BadgeAccessory: String, CaseIterable {
        case a
        case b
        case c
        
        var imageName: String {
            switch self {
            case .a:
                return "Utilities"
            case .b:
                return "Mailbox"
            case .c:
                return "Transport"
            }
        }
    }
    
    static func == (lhs: Accessory, rhs: Accessory) -> Bool {
        lhs.accessoryName == rhs.accessoryName
    }
}
//
//
//class Accessory: Identifiable, Equatable {
//    
//    var image: Image
//    var accessoryType: AccessoryType
//    var accessoryName: String
//    
//    
//    init(accessoryType: AccessoryType, accessoryName: String) {
//        self.accessoryType = accessoryType
//        self.accessoryName = accessoryName
//        
//        switch accessoryType {
//                case .hair(let hairAccessory):
//                    self.image = Image(hairAccessory.imageName)
//                case .badge(let badgeAccessory):
//                    self.image = Image(badgeAccessory.imageName)
//                }
//    }
//    
//    static func == (lhs: Accessory, rhs: Accessory) -> Bool {
//        lhs.accessoryName == rhs.accessoryName
//    }
//    
//    enum AccessoryType {
//        case hair(HairAccessory)
//        case badge(BadgeAccessory)
//    }
//    
//    enum HairAccessory: String, CaseIterable {
//        case a
//        case b
//        case c
//        
//        var imageName: String {
//            switch self {
//            case .a:
//                return "Medicine"
//            case .b:
//                return "TV"
//            case .c:
//                return "Pet"
//            }
//        }
//    }
//
//    enum BadgeAccessory: String, CaseIterable {
//        case a
//        case b
//        case c
//        
//        var imageName: String {
//            switch self {
//            case .a:
//                return "Utilities"
//            case .b:
//                return "Mailbox"
//            case .c:
//                return "Transport"
//            }
//        }
//    }
//}
