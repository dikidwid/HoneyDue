//
//  AchievementsTitleView.swift
//  HoneyDue
//
//  Created by Singgih Tulus Makmud on 24/06/24.
//

import SwiftUI

struct AchievementsTitleView: View {
    @Binding var achievement: Achievement
    var body: some View {
        ZStack{
            Rectangle()
            .foregroundColor(.clear)
            .frame(width: 111, height: 135)
            .background(Color(red: 1, green: 1, blue: 1))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 2, y: 2)
            VStack{
                Image(achievement.imageName)
                    .resizable()
                    .frame(width: 85, height: 85)
                    .padding()

            }
        }
        
    }
}



//#Preview {
//    AchievementsTitleView()
//}
