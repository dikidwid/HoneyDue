//
//  ScanBillPage.swift
//  VisionAI
//
//  Created by Arya Adyatma on 12/06/24.


import SwiftUI
import Combine

struct ScanExpensePage: View {
    @StateObject var nav = ScanExpenseNavigationViewModel()
    
    var body: some View {
        NavigationStack(path: $nav.path) {
            ScanExpenseFragment()
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
        .environmentObject(nav)
    }
}

struct ScanExpenseFragment: View {
    @EnvironmentObject var nav: ScanExpenseNavigationViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel = ScanExpenseViewModel()
    
    var body: some View {
        if viewModel.isScanning {
            ScanExpenseReadingPage(onCancelBtn: { viewModel.closeOverlay() })
        }
        else {
            VStack {
                ZStack {
                    Circle()
                        .foregroundColor(.colorPrimary)
                        .opacity(0.2)
                        .frame(width: 64, height: 64)
                    
                    Text("🤑")
                        .scaleEffect(1.6)
                }
                Text("**Bill Scanner AI**")
                    .font(.title)
                
                Text("Feel the magic of AI to automate your expense tracking 🚀")
                    .padding()
                    .padding(.horizontal)
                
                if !viewModel.isScanning {
                    HStack {
                        Button(action: {
                            viewModel.isShowingActionSheet = true
                        }) {
                            Text("Scan Bill")
                                .padding()
                                .background(.colorPrimary)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                
                NavigationLink {
                    SettingsPage()
                } label: {
                    Text("Settings")
                        .foregroundStyle(.colorPrimary)
                }
                .padding()
                
                ScrollView {
                    Text(viewModel.responseText)
                        .background(.gray.opacity(0.1))
                }
            }
            .padding()
            .padding(.top, 200)
            .sheet(isPresented: $viewModel.isShowingActionSheet) {
                ScanBillBottomSheet(isShowing: $viewModel.isShowingActionSheet, isShowingCamera: $viewModel.isShowingCamera, isShowingPhotoLibrary: $viewModel.isShowingPhotoLibrary)
                    .presentationDetents([.height(220), .medium, .large])
                    .presentationDragIndicator(.hidden)
                    .padding()
                    .padding(.top)
                    .cornerRadius(24)
                    .presentationCornerRadius(24)
            }
            .fullScreenCover(isPresented: $viewModel.isShowingCamera) {
                CameraView(isShowingCamera: $viewModel.isShowingCamera, image: $viewModel.image, uiImage: $viewModel.uiImage)
                    .background(Color.black)
                    .edgesIgnoringSafeArea(.all)
            }
            .fullScreenCover(isPresented: $viewModel.isShowingPhotoLibrary) {
                ImagePicker(image: $viewModel.image, uiImage: $viewModel.uiImage)
            }
            .onChange(of: viewModel.uiImage) { _ in
                viewModel.askVisionAI()
            }
            .onChange(of: viewModel.expenseResult) { _ in
                nav.path.append(ScanExpenseNavigationDestination.validation(viewModel.expenseResult))
            }
        }
    }
}

struct ScanBillBottomSheet: View {
    @Binding var isShowing: Bool
    @Binding var isShowingCamera: Bool
    @Binding var isShowingPhotoLibrary: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 20) {
                Button(action: {
                    isShowingPhotoLibrary = true
                    isShowing = false
                }) {
                    HStack {
                        Image(systemName: "photo.on.rectangle")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.colorCategoryShopping)
                            .clipShape(Circle())
                        Text("Photo Library")
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(24) // Changed corner radius to 24
                    .shadow(color: Color.black.opacity(0.15), radius: 4)
                }
                
                Button(action: {
                    isShowingCamera = true
                    isShowing = false
                }) {
                    HStack {
                        Image(systemName: "camera.fill")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.colorCategoryPet)
                            .clipShape(Circle())
                        Text("Camera")
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(24) // Changed corner radius to 24
                    .shadow(color: Color.black.opacity(0.15), radius: 4)
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 6)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(24) // Changed corner radius to 24
            
            Spacer()
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    ScanExpensePage()
}
