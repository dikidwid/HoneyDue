import SwiftUI

struct NewOnboardingPage: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let description: String
}

struct PageIndicator: View {
    var numberOfPages: Int
    var currentPage: Int
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 112, height: 24)
                .background(Color(red: 0.99, green: 0.93, blue: 0.87))
                .cornerRadius(16)
            
            HStack(spacing: 8) {
                ForEach(0..<numberOfPages) { index in
                    Circle()
                        .fill(index == currentPage ? Color(hex: "FF921E") : Color(hex: "FFD3A6"))
                        .frame(width: 8, height: 8)
                }
            }
        }
    }
}

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showSetCategoryView = false
    @EnvironmentObject var nav: GlobalNavigationViewModel
    
    let pages = [
        NewOnboardingPage(image: "BearPlaceholder", title: "Protect Your Streak with Idle Mode", description: "Going on holiday or not spending at all? Turn on Idle Mode to protect your streak. This way, you can take a break without losing your progress."),
        NewOnboardingPage(image: "BearPlaceholder", title: "Earn Rewards for Your Achievements", description: "Reach your financial goals and unlock rewards! Customize your avatar with exclusive decorations every time you achieve a new milestone."),
        NewOnboardingPage(image: "BearPlaceholder", title: "Personalize Your Profile", description: "Tap your avatar to visit your profile. Here, you can track your achievements, view your rewards, and personalize your experience."),
        NewOnboardingPage(image: "BearPlaceholder", title: "Manage Your Categories", description: "Honeydue provides 10 preset categories to get you started. You can enable or disable categories, rename them, and set your budget for each one directly from the home page."),
        NewOnboardingPage(image: "BearPlaceholder", title: "Scan and Categorize Your Bills", description: "Save time with our Scan Bill feature. Simply take a photo or choose a bill from your gallery, and Honeydue will automatically scan and categorize it based on your selected categories."),
        NewOnboardingPage(image: "BearPlaceholder", title: "Welcome to HoneyDue!", description: "Ready to take control of your finances? Let’s get started!")
    ]
    
    var body: some View {
        ZStack {
            TabView(selection: $currentPage) {
                ForEach(pages.indices, id: \.self) { index in
                    VStack {
                        Image(pages[index].image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 153)
                            .padding()
                        
                        Spacer()
                            .frame(height: 38)
                        
                        VStack {
                            Text(pages[index].title)
                                .font(.system(size: 24, weight: .bold))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                .frame(width: 280, alignment: .top)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Spacer()
                                .frame(height: 16)
                            
                            Text(pages[index].description)
                                .font(.system(size: 14, weight: .medium))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                .frame(width: 330, alignment: .top)
                            
                        }
                        
                        Spacer()
                            .frame(height: 120)
                    }
                    .tag(index)
                    
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            VStack {
                HStack {
                    Spacer()
                    
                    if currentPage < pages.count - 1 {
                        Button(action: {
                            currentPage = pages.count - 1
                        }) {
                            Text("Skip")
                                .font(.system(size: 12, weight: .medium))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 1, green: 0.63, blue: 0.25))
                        }
                    }
                }
                .padding(.horizontal, 16)
                
                Spacer()
            }
            .padding(.top, 62)
            
            VStack {
                Spacer()
                    .frame(height: 400)
                
                PageIndicator(numberOfPages: pages.count, currentPage: currentPage)
            }
            
            VStack {
                Spacer()
                    .frame(height: 520)
                
                if currentPage == pages.count - 1 {
                    HStack {
                        Button {
                            showSetCategoryView = true
                        } label: {
                            CustomButtonView(title: "Get Started")
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            
        }
        .sheet(isPresented: $showSetCategoryView) {
            SetCategoryView()
        }
        .background(Image("OnboardingBg")
            .resizable()
            .scaledToFit()
            .scaleEffect(1.1))
            .ignoresSafeArea()
    }
}

#Preview {
    OnboardingView()
}
