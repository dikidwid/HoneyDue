//
//  Icon.swift
//  HoneyDue
//
//  Created by Singgih Tulus Makmud on 24/06/24.
//

import SwiftUI

struct Icon: Identifiable {
    let id = UUID()
    var position: CGPoint
    var height: Double
    var width: Double
    var category: String
    var isInteractible: Bool
    var imageName: String
    var shine: Bool = true
}


