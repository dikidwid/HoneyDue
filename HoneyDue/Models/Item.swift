//
//  Item.swift
//  HoneyDue
//
//  Created by Singgih Tulus Makmud on 25/06/24.
//

import SwiftUI
import SwiftData

@Model
class Item {
    var image: String
    var positionX: Double
    var positionY: Double
    var width: Double
    
    init(image: String, position: CGPoint, width: Double) {
        self.image = image
        self.positionX = position.x
        self.positionY = position.y
        self.width = width
    }
}

extension Item {
    var position: CGPoint {
        return CGPoint(x: positionX, y: positionY)
    }
    
    static let foodItem = Item(image: "Fridge2", position: CGPoint(x: 0.205, y: 0.1275), width: 110)
    static let transportItem = Item(image: "Transport", position: CGPoint(x: 0.73, y: 0.91), width: 213)
    static let utilitiesItem = Item(image: "Utilities", position: CGPoint(x: 0.19, y: 0.580), width: 50)
    static let clothesItem = Item(image: "Clothes", position: CGPoint(x: 0.685, y: 0.6), width: 62)
    static let healthItem = Item(image: "Medicine", position: CGPoint(x: 0.592, y: 0.123), width: 43)
    static let travelItem = Item(image: "Travel", position: CGPoint(x: 0.8, y: 0.465), width: 112)
    static let othersItem = Item(image: "Mailbox", position: CGPoint(x: 0.085, y: 0.88), width: 50)
    static let petItem = Item(image: "Pet", position: CGPoint(x: 0.54, y: 0.285), width: 51)
    static let entertainmentItem = Item(image: "TV", position: CGPoint(x: 0.89, y: 0.24), width: 92)
    static let workItem = Item(image: "Work", position: CGPoint(x: 0.15, y: 0.4), width: 125)
    
    static let cameraItem = Item(image: "Medicine", position: CGPoint(x: 0.83, y: 0.075), width: 43)
    
}

