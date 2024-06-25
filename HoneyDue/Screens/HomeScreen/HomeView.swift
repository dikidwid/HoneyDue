//
//  HomeView.swift
//  HoneyDue
//
//  Created by Singgih Tulus Makmud on 25/06/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    let shineTimer = Timer.publish(every: 2.5, on: .main, in: .common).autoconnect()
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    
//    @Environment(\.modelContext) var modelContext
    
//    @Query private var categories: [Category]
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            ZStack {
                backgroundView(screenWidth: screenWidth, screenHeight: screenHeight)
                iconsView(screenWidth: screenWidth, screenHeight: screenHeight)
                let calculatedPosition = CGPoint (
                    x: Item.cameraItem.position.x * screenWidth,
                    y: Item.cameraItem.position.y * screenHeight
                )
                Image(Item.cameraItem.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Item.cameraItem.width)
                    .position(calculatedPosition)
                
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
        ForEach(viewModel.categories.indices, id: \.self) { index in
            let item = viewModel.categories[index].item
            let calculatedPosition = CGPoint (
                x: item.position.x * screenWidth,
                y: item.position.y * screenHeight
            )
            ZStack {
                ItemView(item: $viewModel.categories[index].item, isEditMode: $viewModel.isEditMode, shine: $viewModel.shine, calculatedPosition: calculatedPosition, isEnable: $viewModel.categories[index].isEnable)
                
                ItemViewTapArea(item: $viewModel.categories[index].item,
                                isEditMode: $viewModel.isEditMode,
                                calculatedPosition: calculatedPosition,
                                isEnable: $viewModel.categories[index].isEnable)
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

#Preview {
//    ModelContainerPreview(ModelContainer.sample) {
        HomeView(viewModel: HomeViewModel(dataSource: CategoryDataSource.shared))
//    }
}
