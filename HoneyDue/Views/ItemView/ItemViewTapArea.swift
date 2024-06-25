//
//  ItemViewTapArea.swift
//  HoneyDue
//
//  Created by Singgih Tulus Makmud on 25/06/24.
//

import SwiftUI

struct ItemViewTapArea: View {
    @Binding var item: Item
    @Binding var isEditMode: Bool
    var calculatedPosition: CGPoint
    @Binding var isEnable: Bool
    
    var body: some View {
        ZStack {
            
            Image(item.image)
                .resizable()
                .scaledToFit()
                .frame(width: item.width)
                .position(calculatedPosition)
                .opacity(isEnable ? 0.01 : 1)
                .onTapGesture {
                    if self.isEditMode {
                        isEnable.toggle()
                        print(isEnable)
                    }
                    else if isEnable {
                        print(item.image)
                    }
                }
            
            
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
