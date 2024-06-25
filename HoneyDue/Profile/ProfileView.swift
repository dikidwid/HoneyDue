//
//  ProfileView.swift
//  HoneyDue
//
//  Created by Singgih Tulus Makmud on 24/06/24.
//

import SwiftUI

struct ProfileView: View {
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @State var achievements: [Achievement] = Achievement.seedAchievements()
    @State private var showAllAchievements = false
    @State private var username: String = "Singgih Tulus Makmud"
    @State private var isEditing: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader{ geometry in
            NavigationView{
                ZStack{
                    Rectangle()
                        .fill(.blue)
                    VStack{
                        HStack{
                            Image(systemName: "arrow.left")
                                .frame(width: 21, height: 22)
                                .foregroundColor(.black)
                                .bold()
                                .onTapGesture {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            
                            Spacer()
                            Image(systemName: "gearshape")
                                .foregroundColor(.white)
                                .frame(width: 26, height: 22)
                                .bold()
                            
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 65)
                        Spacer()
                    }
                    
                    VStack(spacing: 0){
                        ZStack{
                            Image("avatar")
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width)
                            Rectangle()
                                .frame(width: 230, height: 400)
                                .border(.red)
                                .foregroundColor(.clear)
                                .onTapGesture {
                                    
                                }
                        }
                        
                        Rectangle()
                            .foregroundColor(.white)
                            .frame(height: 500)
                            .cornerRadius(20)
                            .overlay{
                                VStack(alignment: .leading) {
                                    
                                    HStack {
                                        Text("Hello, \(username)")
                                            .font(.system(size: 16))
                                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                    }
                                    
                                    Text("Joined since June 2024")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color(red: 0.38, green: 0.38, blue: 0.38))
                                        .padding(.top, 1)
                                    
                                    Text("Your Record")
                                        .font(.system(size: 18))
                                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                        .bold()
                                        .padding(.top)
                                    
                                    HStack {
                                        ZStack {
                                            Rectangle()
                                                .foregroundColor(.clear)
                                                .frame(width: 173, height: 76)
                                                .background(Color(red: 1, green: 1, blue: 1))
                                                .cornerRadius(16)
                                                .shadow(color: .black.opacity(0.1), radius: 5, x: 2, y: 2)
                                            
                                            HStack {
                                                Image("Medicine")
                                                    .resizable()
                                                    .frame(width: 30, height: 30)
                                                
                                                VStack(alignment: .leading) {
                                                    Text("99")
                                                        .font(.system(size: 24))
                                                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                                        .fontWeight(.bold)
                                                    
                                                    Text("Highest Streak")
                                                        .font(Font.custom("SF Pro", size: 12).weight(.semibold))
                                                        .foregroundColor(Color(red: 0.62, green: 0.62, blue: 0.62))
                                                }
                                            }
                                        }
                                        
                                        ZStack {
                                            Rectangle()
                                                .foregroundColor(.clear)
                                                .frame(width: 173, height: 76)
                                                .background(Color(red: 1, green: 1, blue: 1))
                                                .cornerRadius(16)
                                                .shadow(color: .black.opacity(0.1), radius: 5, x: 2, y: 2)
                                            
                                            HStack {
                                                Image("Medicine")
                                                    .resizable()
                                                    .frame(width: 30, height: 30)
                                                
                                                VStack(alignment: .leading) {
                                                    Text("99")
                                                        .font(.system(size: 24))
                                                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                                        .fontWeight(.bold)
                                                    
                                                    Text("Highest Streak")
                                                        .font(Font.custom("SF Pro", size: 12).weight(.semibold))
                                                        .foregroundColor(Color(red: 0.62, green: 0.62, blue: 0.62))
                                                }
                                            }
                                        }
                                    }
                                    
                                    HStack {
                                        Text("Your Achievements")
                                            .font(.system(size: 18))
                                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                            .bold()
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            withAnimation {
                                                showAllAchievements.toggle()
                                            }
                                        }) {
                                            NavigationLink("VIEW ALL", destination: AllAchievementsView(achievements: $achievements))
                                                .font(.system(size: 10))
                                                .bold()
                                                .foregroundColor(Color(red: 0.62, green: 0.62, blue: 0.62))
                                        }
                                    }
                                    .padding(.top)
                                    
                                    LazyVGrid(columns: columns) {
                                        if showAllAchievements {
                                            
                                            
                                        } else {
                                            ForEach(Array($achievements.prefix(3))) { achievement in
                                                AchievementsTitleView(achievement: achievement)
                                            }
                                        }
                                        
                                    }
                                    
                                    Spacer()
                                }
                                .padding(16)
                            }
                    }
                }}
        }
    }
}

#Preview {
    ProfileView()
}

