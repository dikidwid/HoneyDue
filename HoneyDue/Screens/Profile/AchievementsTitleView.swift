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
                    .frame(width: 40, height: 40)
                    .padding()
                    
                Text(achievement.name)
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 0.62, green: 0.62, blue: 0.62))

            }
        }
        
    }
}



//#Preview {
//    AchievementsTitleView()
//}
