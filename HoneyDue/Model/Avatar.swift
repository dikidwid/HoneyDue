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
        self.addAccessory(Accessory(accessoryType: .badge(.c), accessoryName: "badgeC"))

    }
}

extension Avatar {
    static let maleAvatar = {
        let avatar = Avatar(name: "", ownedAccessories: [], selectedHair: Accessory(accessoryType: .hair(.hair1), accessoryName: "hair1"), gender: .male)
        avatar.avatarSeeder()
        return avatar
    }
    
}


