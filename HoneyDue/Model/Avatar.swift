//
//  Avatar.swift
//  HoneyDue
//
//  Created by Singgih Tulus Makmud on 25/06/24.
//

import SwiftUI


class Avatar: ObservableObject {
    var id = UUID()
    @Published var name: String
    @Published var ownedAccessories: [Accessory] = []
    @Published var selectedHair: Accessory?
    @Published var selectedBadge: Accessory?
    @Published var showProfile = false
    
    var gender: Gender
    enum Gender {
        case male
        case female
        var image: Image {
            switch self {
            case .male:
                return Image("maleAvatar")
            case .female:
                return Image("femaleAvatar")
            }
        }
    }
    
    init(name: String, ownedAccessories: [Accessory] = [], selectedHair: Accessory? = nil, selectedBadge: Accessory? = nil, gender: Gender) {
        self.name = name
        self.ownedAccessories = ownedAccessories
        self.selectedHair = selectedHair
        self.selectedBadge = selectedBadge
        self.gender = gender
    }
    
    func addAccessory(_ accessory: Accessory) {
            ownedAccessories.append(accessory)
        }
    
    func avatarSeeder(){
        self.name = "Singgih"
        self.gender = .male
        self.addAccessory(Accessory(accessoryType: .hair(.hair1), accessoryName: "hair1"))
        self.addAccessory(Accessory(accessoryType: .hair(.hair2), accessoryName: "hair2"))
        self.addAccessory(Accessory(accessoryType: .hair(.hair3), accessoryName: "hair3"))
        self.addAccessory(Accessory(accessoryType: .hair(.hair4), accessoryName: "hair4"))
        self.addAccessory(Accessory(accessoryType: .hair(.hair5), accessoryName: "hair5"))
        self.addAccessory(Accessory(accessoryType: .hair(.hair6), accessoryName: "hair6"))
        self.addAccessory(Accessory(accessoryType: .badge(.firstTracker), accessoryName: "firstTracker"))
        self.addAccessory(Accessory(accessoryType: .badge(.reportReady), accessoryName: "reportReady"))
        self.addAccessory(Accessory(accessoryType: .badge(.receiptRecorder), accessoryName: "receiptRecorder"))

    }
}

extension Avatar {
    static let maleAvatar = {
        let avatar = Avatar(name: "", ownedAccessories: [], selectedHair: Accessory(accessoryType: .hair(.hair1), accessoryName: "hair1"), gender: .male)
        avatar.avatarSeeder()
        avatar.selectedBadge = avatar.ownedAccessories.last
        return avatar
    }
    
}


