//
//  IconViewNoShine.swift
//  HoneyDue
//
//  Created by Singgih Tulus Makmud on 24/06/24.
//

import SwiftUI

struct IconViewNoShine: View {
    @Binding var icon: Icon
    @Binding var isEditMode: Bool
    @Binding var shine: Bool
    
    var calculatedPosition: CGPoint
    
    var body: some View {
        GeometryReader{ geometry in
    
                        
            Image(icon.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: icon.width)
                .position(calculatedPosition)
                .onTapGesture {
                    if self.isEditMode {
                        icon.isInteractible.toggle()
                        print(icon.isInteractible)
                    }
                    if icon.isInteractible {
                        print(icon.imageName)
                    }
                }
            
                
            if self.isEditMode {
                Image(systemName: icon.isInteractible ? "minus.circle.fill" : "plus.circle.fill")
                    .foregroundColor(icon.isInteractible ? .red : .blue)
                    .background(Circle().fill(Color.white))
                    .position(x: calculatedPosition.x, y: calculatedPosition.y)
                    .onTapGesture {
                        icon.isInteractible.toggle()
                    }
                
            }
            
        }
        
    }
}


