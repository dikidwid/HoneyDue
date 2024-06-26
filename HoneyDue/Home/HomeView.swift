//
//  HomeView.swift
//  HoneyDue
//
//  Created by Singgih Tulus Makmud on 24/06/24.
//

import SwiftUI

struct HomeView: View {
    let shineTimer = Timer.publish(every: 2.5, on: .main, in: .common).autoconnect()
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    @StateObject var avatar: Avatar = .maleAvatar()
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            ZStack {
                backgroundView(screenWidth: screenWidth, screenHeight: screenHeight)
                ZStack{
                    AvatarView(avatar: avatar)
                        .frame(width: 150)
                        .position(CGPoint(x: 170.0, y: 440.0))
                        .onTapGesture {
                            //here
                        }
            
                }
                
                
                    
                iconsView(screenWidth: screenWidth, screenHeight: screenHeight)
                editModeControls()
            }
            .onReceive(shineTimer) { _ in
                viewModel.shine.toggle()
            }
            .onLongPressGesture {
                viewModel.toggleEditMode()
            }
//            .overlay()
        }
    }
    
    private func backgroundView(screenWidth: CGFloat, screenHeight: CGFloat) -> some View {
        Image("bg2")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .edgesIgnoringSafeArea(.all)
            .frame(width: screenWidth, height: screenHeight)
            .overlay(
                Color.black.opacity(viewModel.isEditMode ? 0.6 : 0)
                    .edgesIgnoringSafeArea(.all)
            )
    }
    
    private func iconsView(screenWidth: CGFloat, screenHeight: CGFloat) -> some View {
        ForEach(viewModel.icons.indices, id: \.self) { index in
            let icon = viewModel.icons[index]
            let calculatedPosition = CGPoint(
                x: icon.position.x * screenWidth,
                y: icon.position.y * screenHeight
            )
            ZStack {
                IconView(icon: $viewModel.icons[index], isEditMode: $viewModel.isEditMode, shine: $viewModel.shine, calculatedPosition: calculatedPosition)
                IconViewNoShine(icon: $viewModel.icons[index], isEditMode: $viewModel.isEditMode, shine: Binding.constant(false), calculatedPosition: calculatedPosition)
                    .opacity(icon.isInteractible ? 0.01 : 1)
                    .onTapGesture {
                       
                    }
            }
        }
    }
    
    private func editModeControls() -> some View {
        VStack {
            if viewModel.isEditMode {
                HStack(alignment: .center) {
                    Button(action: {
                        viewModel.cancelEditMode()
                    }) {
                        buttonContent(text: "Cancel")
                    }
                    .frame(width: 90)
                    Spacer()
                    Button(action: {
                        viewModel.toggleEditMode()
                    }) {
                        buttonContent(text: "Done")
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 15)
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private func buttonContent(text: String) -> some View {
        Rectangle()
            .fill(Color.white)
            .frame(width: 80, height: 36)
            .cornerRadius(20)
            .overlay {
                Text(text)
                    .foregroundColor(.black)
                    .font(.system(.body, weight: .semibold))
            }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
