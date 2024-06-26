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
    @StateObject var avatar: Avatar = .maleAvatar()
    
    // Scan Expense
    @StateObject var scanExpenseViewModel = ScanExpenseViewModel()
    @StateObject var scanExpenseNav = ScanExpenseNavigationViewModel()
    
    @State var showProfile = false
    
    //    @Environment(\.modelContext) var modelContext
    
    //    @Query private var categories: [Category]
    
    var body: some View {
        NavigationStack(path: $scanExpenseNav.path) {
            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                let screenHeight = geometry.size.height

                ZStack {
                    backgroundView(screenWidth: screenWidth, screenHeight: screenHeight)
                    
                    ZStack {
                        AvatarView(avatar: avatar)
                            .frame(width: 150)
                            .position(CGPoint(x: 170.0, y: 440.0))
                            .onTapGesture {
                                showProfile = true
                            }
                    }
                    
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
                        .onTapGesture {
                            scanExpenseViewModel.isShowingActionSheet = true
                        }
                    
                    editModeControls()
                }
                .sheet(isPresented: $scanExpenseViewModel.isShowingActionSheet) {
                    ScanBillBottomSheet(
                        isShowing: $scanExpenseViewModel.isShowingActionSheet,
                        isShowingCamera: $scanExpenseViewModel.isShowingCamera,
                        isShowingPhotoLibrary: $scanExpenseViewModel.isShowingPhotoLibrary
                    )
                    .presentationDetents([.height(220), .medium, .large])
                    .presentationDragIndicator(.hidden)
                    .padding()
                    .padding(.top)
                    .cornerRadius(24)
                    .presentationCornerRadius(24)
                }
                .fullScreenCover(isPresented: $scanExpenseViewModel.isShowingCamera) {
                    CameraView(
                        isShowingCamera: $scanExpenseViewModel.isShowingCamera,
                        image: $scanExpenseViewModel.image,
                        uiImage: $scanExpenseViewModel.uiImage
                    )
                    .background(Color.black)
                    .edgesIgnoringSafeArea(.all)
                }
                .fullScreenCover(isPresented: $scanExpenseViewModel.isShowingPhotoLibrary) {
                    ImagePicker(
                        image: $scanExpenseViewModel.image,
                        uiImage: $scanExpenseViewModel.uiImage
                    )
                }
                .onChange(of: scanExpenseViewModel.uiImage) { _ in
                    scanExpenseViewModel.askVisionAI()
                }
                .onChange(of: scanExpenseViewModel.expenseResult) { _ in
                    scanExpenseNav.path.append(ScanExpenseNavigationDestination.validation(scanExpenseViewModel.expenseResult))
                }
                .onReceive(shineTimer) { _ in
                    viewModel.shine.toggle()
                }
                .onLongPressGesture {
                    viewModel.toggleEditMode()
                }
            }
            .navigationDestination(for: ScanExpenseNavigationDestination.self) { destination in
                switch destination {
                case .validation(let result):
                    ScanExpenseValidationPage(expenseResult: result)
                case .selectTransaction(let result):
                    ScanExpenseSelectTransactionPage(
                        viewModel: ScanExpenseSelectTransactionViewModel(expenseResult: result)
                    )
                case .success:
                    ScanExpenseSuccessPage()
                }
            }
        }
        .fullScreenCover(isPresented: $showProfile) {
            ProfileView()
        }
        .overlay {
            if scanExpenseViewModel.isScanning {
                HStack {
                    Spacer()
                    ScanExpenseReadingPage(onCancelBtn: { scanExpenseViewModel.isScanning = false })
                    Spacer()
                }
                .background(.white)
            }
            
            NotificationView(notification: scanExpenseViewModel.customNotification)
                .shadow(color: .black.opacity(0.5), radius: 10)
                .frame(maxHeight: .infinity, alignment: .top)
                .offset(y: scanExpenseViewModel.isShowCustomNotification ? 0 : -150)
                .animation(.interpolatingSpring, value: scanExpenseViewModel.isShowCustomNotification)
        }
        .statusBar(hidden: true)
        .environmentObject(scanExpenseNav)
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
