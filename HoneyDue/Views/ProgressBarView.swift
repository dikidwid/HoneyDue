//
//  ProgressBarView.swift
//  iTrack
//
//  Created by Diki Dwi Diro on 25/06/24.
//

import SwiftUI

struct ProgressBarView: View {
    let progress: Double
    var isShowPercentage: Bool = true
    var progressBarColor: Color {
        let percentage = progress * 100
        if percentage > 0 && percentage <= 30 {
            return .redProgressColor
        } else if percentage > 30 && percentage <= 60 {
            return .orangeProgressColor
        } else if percentage > 60 && percentage <= 100 {
            return .greenProgressColor
        } else {
            return .black.opacity(0.085)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundStyle(.black.opacity(0.05))
                
                Rectangle()
                    .foregroundStyle(progressBarColor)
                    .frame(width: min(CGFloat(self.progress) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .animation(.interpolatingSpring(duration: 2), value: progress)
                
                if isShowPercentage {
                    Text("\(Float(progress * 100), specifier: "%.0f")%")
                        .font(.system(.headline))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .cornerRadius(20)
        }
    }
}

#Preview {
    ProgressBarView(progress: 0.7, isShowPercentage: true)
}
