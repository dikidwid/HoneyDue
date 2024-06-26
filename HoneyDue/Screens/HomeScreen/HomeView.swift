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
    @ObservedObject var viewModel: HomeViewModel
    @StateObject var avatar: Avatar = .maleAvatar()
    
    @StateObject var scanExpenseViewModel = ScanExpenseViewModel()
    @StateObject var scanExpenseNav = ScanExpenseNavigationViewModel()
    @StateObject var overviewViewModel = OverviewViewModel()
    
    @State private var isBlinkCameraItem: Bool = false
//    @State private var isBlinkOverviewItem: Bool = false
//    @State var showProfile: Bool = false
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
                        AvatarViewHome(avatar: avatar)
                            .frame(width: 150)
                            .position(CGPoint(x: 190.0, y: 400.0))
                    }
                    .overlay {
                        Rectangle()
                            .frame(width: 75, height: 140)
                            .foregroundColor(.white.opacity(0.00000001))
                            .onTapGesture {
                                if !viewModel.isEditMode {
                                    avatar.showProfile.toggle()
                                }
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
                        .overlay {
                            Image(Item.cameraItem.image)
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .foregroundStyle(.white)
                                .frame(width: Item.cameraItem.width)
                                .position(calculatedPosition)
                                .opacity(isBlinkCameraItem ? 0.6 : 0)

                        }
                        .onAppear {
                            withAnimation(.easeIn.repeatForever(autoreverses: true).speed(0.4)) {
                                isBlinkCameraItem.toggle()
                            }
                        }
                        .onTapGesture {
                            if !viewModel.isEditMode {
                                scanExpenseViewModel.isShowingActionSheet = true
                            }
                        }

                    
                    let calculatedPositionOverview = CGPoint (
                        x: Item.overviewItem.position.x * screenWidth,
                        y: Item.overviewItem.position.y * screenHeight
                    )
                    Image(Item.overviewItem.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: Item.overviewItem.width)
                        .position(calculatedPositionOverview)
                        .overlay {
                            Image(Item.overviewItem.image)
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .foregroundStyle(.white)
                                .frame(width: Item.overviewItem.width)
                                .position(calculatedPositionOverview)
                                .opacity(isBlinkCameraItem ? 0.6 : 0)

                        }
                        .onTapGesture {
                            if !viewModel.isEditMode {
                                overviewViewModel.isShowingOverview.toggle()
                            }
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
                .fullScreenCover(isPresented: $overviewViewModel.isShowingOverview) {
                    OverviewPageView(homeViewModel: viewModel)
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
                    withAnimation {
                        viewModel.toggleEditMode()
                    }
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
        .fullScreenCover(isPresented: $avatar.showProfile){
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
        .sheet(isPresented: $viewModel.isShowDetailCategory) {
            ExpenseDetailView(category: viewModel.selectedCategory, isShowAddExpense: $viewModel.isShowAddExpenseView)
                .padding(.all, 5)
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(.modalityCornerRadius)
                .presentationDetents([.fraction(0.7)])
        }
        .statusBar(hidden: true)
        .environmentObject(scanExpenseNav)
        .environmentObject(avatar)
        .environmentObject(overviewViewModel)
        .environmentObject(viewModel)
        .modelContainer(CategoryDataSource.shared.modelContainer)
    }
    
    private func backgroundView(screenWidth: CGFloat, screenHeight: CGFloat) -> some View {
        Image("Background")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: screenWidth, height: screenHeight)
            .scaleEffect(1.025)
            .offset(y: -15)
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
                
                ItemViewTapArea(category: $viewModel.categories[index],
                                selectedCategory: $viewModel.categories[index],
                                isEditMode: $viewModel.isEditMode,
                                calculatedPosition: calculatedPosition)
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

struct AvatarViewHome: View{
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
            
            if let selectedBadge = avatar.selectedBadge {
                selectedBadge.image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .offset(x: -6.5, y: 5)
            }
        }
    }
}

#Preview {
    //    ModelContainerPreview(ModelContainer.sample) {
    HomeView(viewModel: HomeViewModel(dataSource: CategoryDataSource.shared))
    //    }
}
