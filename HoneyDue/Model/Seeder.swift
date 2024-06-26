//
//  Seeder.swift
//  HoneyDue
//
//  Created by Singgih Tulus Makmud on 24/06/24.
//
import SwiftUI

extension Icon {
    static func seedIcons() -> [Icon] {
        return [
            Icon(position: CGPoint(x: 0.205, y: 0.1275), height: 400, width: 110, category: "F&B", isInteractible: true, imageName: "kulkas2"),
            Icon(position: CGPoint(x: 0.73, y: 0.91), height: 400, width: 213, category: "F&B", isInteractible: true, imageName: "Transport"),
            Icon(position: CGPoint(x: 0.19, y: 0.580), height: 400, width: 50, category: "F&B", isInteractible: true, imageName: "Utilities"),
            Icon(position: CGPoint(x: 0.685, y: 0.6), height: 400, width: 62, category: "F&B", isInteractible: true, imageName: "Clothes"),
            Icon(position: CGPoint(x: 0.592, y: 0.123), height: 400, width: 43, category: "F&B", isInteractible: true, imageName: "Medicine"),
            Icon(position: CGPoint(x: 0.8, y: 0.465), height: 400, width: 112, category: "F&B", isInteractible: true, imageName: "Travel"),
            Icon(position: CGPoint(x: 0.085, y: 0.88), height: 400, width: 50, category: "F&B", isInteractible: true, imageName: "Mailbox"),
            Icon(position: CGPoint(x: 0.54, y: 0.285), height: 400, width: 51, category: "F&B", isInteractible: true, imageName: "Pet"),
            Icon(position: CGPoint(x: 0.89, y: 0.24), height: 400, width: 92, category: "F&B", isInteractible: true, imageName: "TV"),
            Icon(position: CGPoint(x: 0.15, y: 0.4), height: 400, width: 125, category: "F&B", isInteractible: true, imageName: "Work"),
        ]
    }
}

extension Achievement {
    static func seedAchievements() -> [Achievement] {
        return [
            Achievement(imageName: "Medicine", name: "Test", description: "lorem ipsum"),
            Achievement(imageName: "Medicine", name: "Test", description: "lorem ipsum"),
            Achievement(imageName: "Medicine", name: "Test", description: "lorem ipsum"),
            Achievement(imageName: "Medicine", name: "Test", description: "lorem ipsum"),
            Achievement(imageName: "Medicine", name: "Test", description: "lorem ipsum"),
            Achievement(imageName: "Medicine", name: "Test", description: "lorem ipsum"),
            Achievement(imageName: "Medicine", name: "Test", description: "lorem ipsum"),
            Achievement(imageName: "Medicine", name: "Test", description: "lorem ipsum"),
            Achievement(imageName: "Medicine", name: "Test", description: "lorem ipsum"),
            Achievement(imageName: "Medicine", name: "Test", description: "lorem ipsum"),
            Achievement(imageName: "Medicine", name: "Test", description: "lorem ipsum")
        ]
    }
}

