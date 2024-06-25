//
//  CustomButtonView.swift
//  iTrack
//
//  Created by Diki Dwi Diro on 25/06/24.
//

import SwiftUI

struct CustomButtonView: View {
    let title: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.appPrimary)
            .overlay {
                Text(title)
                    .font(.system(.title3, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .frame(height: 50)
    }
}

#Preview {
    CustomButtonView(title: "Button")
}
