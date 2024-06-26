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
                .border(.red)
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

extension View {
    @ViewBuilder
    func shine(_ toggle: Bool, duration: CGFloat) -> some View {
        self
            .overlay {
                GeometryReader {
                    let size = $0.size
                    
                    let gradient = LinearGradient(
                        gradient: Gradient(colors: [
                            .clear,
                            .white.opacity(0.1),
                            .white.opacity(0.5),
                            .white.opacity(1),
                            .white.opacity(0.5),
                            .white.opacity(0.1),
                            .clear,
                            .clear,
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    
                    
                    Rectangle()
                        .fill(gradient)
                        .scaleEffect(y: 8)
                        .frame(width: size.width, height: size.height)
                        .keyframeAnimator(initialValue: 0.0, trigger: toggle, content: { content, progress in
                            content
                                .offset(x: -size.width + (progress * (size.width * 3)))
                        }, keyframes: { _ in
                            CubicKeyframe(.zero, duration: 0.1)
                            CubicKeyframe(1, duration: duration)
                        })
                        .rotationEffect(.degrees(45))
                }
            }
            .mask(self)
    }
}

