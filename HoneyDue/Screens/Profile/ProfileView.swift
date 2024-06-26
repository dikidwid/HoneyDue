//
//  ProfileView.swift
//  HoneyDue
//
//  Created by Singgih Tulus Makmud on 24/06/24.
//

import SwiftUI

struct ProfileView: View {
    
    @State var achievements: [Achievement] = Achievement.seedAchievements()
    @State private var showAllAchievements = false
    @State private var isEditing: Bool = false
    @State private var selectedOption: String = "All"
    @StateObject private var avatar: Avatar = .maleAvatar()
    
    
    var body: some View {
        GeometryReader{ geometry in
            NavigationView{
                ZStack{
                    Rectangle()
                        .fill(.blue)
                    
                    AvatarView(avatar: avatar)
                        .offset(y: -180)
                    
                    ProfileHeader(isEditing: $isEditing)
                    
                    
                    VStack(spacing: 0){
                        ZStack{
                            Rectangle()
                                .frame(width: 230, height: 350)
                                .opacity(0.01)
                                .border(.red)
                                .onTapGesture {
                                    isEditing.toggle()
                                }
                        }
                        
                        ZStack {
                            ProfileOverlay(username: avatar.name, achievements: $achievements, showAllAchievements: $showAllAchievements)
                                .overlay{
                                    if isEditing {
                                        ZStack{
                                            Rectangle()
                                                .fill(Color.white)
                                                .frame(height: 550)
                                                .cornerRadius(20)
                                            EditingOverlay(selectedOption: $selectedOption, avatar: avatar)
                                        }.transition(.move(edge: .bottom))
                                        
                                    }
                                }
                        }
                        .animation(.easeInOut(duration: 0.3), value: isEditing)
                        
                    }
                }
            }
        }
    }
}

struct EditingOverlay: View {
    @Binding var selectedOption: String
    @ObservedObject var avatar: Avatar
    
    let options = ["All", "Hair", "Badge"]
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    var body: some View {
        
        let ownedHair = avatar.ownedAccessories.filter { accessory in
            if case .hair = accessory.accessoryType {
                return true
            } else {
                return false
            }
        }
        
        let ownedBadge = avatar.ownedAccessories.filter { accessory in
            if case .badge = accessory.accessoryType {
                return true
            } else {
                return false
            }
        }
        
        VStack {
            HStack {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        withAnimation {
                            selectedOption = option
                            print(ownedHair[0].accessoryName)
                        }
                    }) {
                        Text(option)
                            .font(.system(size: 17))
                            .fontWeight(.semibold)
                            .foregroundColor(selectedOption == option ? .black : Color(red: 0.63, green: 0.63, blue: 0.63))
                            .padding(.horizontal, 13)
                        
                    }
                }
                Spacer()
            }
            .padding()
            
            TabView(selection: $selectedOption) {
                ForEach(options, id: \.self) { option in
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            
                            ForEach(option == "Hair" ? ownedHair : option == "Badge" ? ownedBadge : avatar.ownedAccessories) { accessory in
                                AccessoryItemView(category: option, accessory: accessory, avatar: avatar)
                            }
                        }
                    }
                    .tag(option)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .padding()
    }
}

struct AccessoryItemView: View {
    let category: String
    let accessory: Accessory
    @ObservedObject var avatar: Avatar
    
    var body: some View {
        let isClicked = getIsClicked()
        
        Rectangle()
            .foregroundColor(isClicked ? .blue : .white)
            .frame(width: 110, height: 110)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 2, y: 2)
            .overlay(
                VStack {
                    accessory.image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 110, height: 110)
                    
                }
                    .offset(y: 25)
                    .clipShape(Rectangle())
                    .border(.red)
            )
            .onTapGesture {
                if accessory.getAccessoryType() == "hair" {
                    avatar.selectedHair = accessory
                } else {
                    avatar.selectedBadge = accessory
                }
            }
    }
    
    func getIsClicked() -> Bool {
        if accessory.getAccessoryType() == "hair" {
            return avatar.selectedHair == accessory
        }
        return avatar.selectedBadge == accessory
    }
    
}

struct ProfileOverlay: View{
    var username: String
    @Binding var achievements: [Achievement]
    @Binding var showAllAchievements: Bool
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    var body: some View{
        Rectangle()
            .foregroundColor(.white)
            .frame(height: 550)
            .cornerRadius(20)
            .overlay {
                VStack(alignment: .leading) {
                    
                    HStack {
                        Text("Hello, \(username)")
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
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
                        RecordCardView(title: "Highest Streak", value: "45", imageName: "Medicine")
                        RecordCardView(title: "Current Streak", value: "99", imageName: "Medicine")
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
                            ForEach($achievements) { achievement in
                                AchievementsTitleView(achievement: achievement)
                            }
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
}

struct AvatarView: View{
    @ObservedObject var avatar: Avatar
    var body: some View{
        ZStack{
            avatar.gender.image
                .resizable()
                .scaledToFit()
            
            if let selectedHair = avatar.selectedHair {
                selectedHair.image
                    .resizable()
                    .scaledToFit()
            }
            
        }
    }
}

struct ProfileHeader: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isEditing: Bool
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "arrow.left")
                    .frame(width: 21, height: 22)
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                        if isEditing{
                            isEditing.toggle()
                        }
                    }
                
                Spacer()
                
                NavigationLink(destination: SettingsPage()) {
                    Image(systemName: "gearshape")
                        .foregroundColor(.white)
                        .frame(width: 26, height: 22)
                        .bold()

                }
                
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 65)
            
            Spacer()
        }
    }
}

#Preview {
    NavigationView {
        ProfileView()
    }
}
