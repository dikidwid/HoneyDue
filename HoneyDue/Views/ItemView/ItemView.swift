//
//  ItemView.swift
//  HoneyDue
//
//  Created by Singgih Tulus Makmud on 25/06/24.
//

import SwiftUI

struct ItemView: View {
    @Binding var item: Item
    @Binding var isEditMode: Bool
    @Binding var shine: Bool
    var calculatedPosition: CGPoint
    @Binding var isEnable: Bool
    
    var body: some View {
        GeometryReader { geometry in
            Image(item.image)
                .resizable()
                .scaledToFit()
                .frame(width: item.width)
                .position(calculatedPosition)
                .shine(shine, duration: 0.5)

            
            if self.isEditMode {
                Image(systemName: isEnable ? "minus.circle.fill" : "plus.circle.fill")
                    .foregroundColor(isEnable ? .red : .blue)
                    .background(Circle().fill(Color.white))
                    .position(x: calculatedPosition.x, y: calculatedPosition.y)
                    .onTapGesture {
                        isEnable.toggle()
                    }
            }
        }

        
    }
}
