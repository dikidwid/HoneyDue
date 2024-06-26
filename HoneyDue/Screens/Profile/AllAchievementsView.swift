import SwiftUI

struct AllAchievementsView: View {
    @Binding var achievements: [Achievement]
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarBack(title: "Achievements")
                .padding(.horizontal)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Your Record")
                        .font(.system(size: 18))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                        .bold()
                        .padding(.top)
                    
                    HStack{
                        RecordCardView(title: "Current Streak", value: "45", imageName: "Streak")
                        RecordCardView(title: "Highest Streak", value: "99", imageName: "Streak")
                    }
                    
                    Text("Your Achievements")
                        .font(.system(size: 18))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                        .bold()
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach($achievements) { $achievement in
                            AchievementsTitleView(achievement: $achievement)
                        }
                    }
                }
                .padding()
            }
            .ignoresSafeArea(edges: /*@START_MENU_TOKEN@*/.bottom/*@END_MENU_TOKEN@*/)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct RecordCardView: View {
    var title: String
    var value: String
    var imageName: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 2, y: 2)
                .frame(width: 173, height: 76)
            
            HStack(spacing: 16) {
                Image(imageName)
                    .resizable()
                    .frame(width: 55, height: 55)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(value)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    
                    Text(title)
                        .font(Font.custom("SF Pro", size: 12).weight(.semibold))
                        .foregroundColor(Color(red: 0.62, green: 0.62, blue: 0.62))
                }
                
            }
            .padding()
        }
        
    }
}

struct AllAchievementsView_Previews: PreviewProvider {
    @State static var achievements = Achievement.seedAchievements()
    
    static var previews: some View {
        NavigationView {
            AllAchievementsView(achievements: $achievements)
        }
    }
}
