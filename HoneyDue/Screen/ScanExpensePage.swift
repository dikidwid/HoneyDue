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
    
    @State private var isShowingCamera = false
    @State private var isShowingPhotoLibrary = false
    @State private var image: Image? = nil
    @State private var responseText: String = ""
    @State private var isLoading = false
    @State private var question: String = "Scan this bill. Categories: \(TransactionCategory.getCategoryNames()). Do not use categories other than this."
    @State private var shouldNavigateNext = false
    @State private var isShowingActionSheet = false
    
    @State private var uiImage: UIImage? = nil
    @State private var expenseResult: ScanExpenseResult = ScanExpenseResult.getExample() {
        didSet {
            DispatchQueue.main.async {
                shouldNavigateNext = true
                print("SHOULD NAVIGATE!! by didSet")
            }
        }
    }
    
    @ObservedObject var viewModel = AIService(
        identifier: FakeAPIKey.expenseScanner.rawValue,
        useStreaming: false,
        isConversation: false
    )
    
    var body: some View {
        if isLoading {
            ScanExpenseReadingPage(onCancelBtn: { cancelVisionAI() })
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
                
                if !isLoading {
                    HStack {
                        Button(action: {
                            isShowingActionSheet = true
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
                    Text(responseText)
                        .background(.gray.opacity(0.1))
                }
                
            }
            .padding()
            .padding(.top, 200)
            .sheet(isPresented: $isShowingActionSheet) {
                CustomBottomSheet(isShowing: $isShowingActionSheet, isShowingCamera: $isShowingCamera, isShowingPhotoLibrary: $isShowingPhotoLibrary)
                    .presentationDetents([.height(220), .medium, .large])
                    .presentationDragIndicator(.hidden)
                    .padding()
                    .padding(.top)
                    .cornerRadius(24)
                    .presentationCornerRadius(24)
            }
            .fullScreenCover(isPresented: $isShowingCamera) {
                CameraView(isShowingCamera: $isShowingCamera, image: $image, uiImage: $uiImage)
                    .background(Color.black)
                    .edgesIgnoringSafeArea(.all)
            }
            .fullScreenCover(isPresented: $isShowingPhotoLibrary) {
                ImagePicker(image: $image, uiImage: $uiImage)
            }
            .onChange(of: uiImage) { _ in
                askVisionAI()
            }
        }
    }
    
    func askVisionAI() {
        self.expenseResult = ScanExpenseResult.getFromAIResponse()
        cancelVisionAI()
        nav.path.append(ScanExpenseNavigationDestination.validation(expenseResult))
        return
        
        guard let uiImage = uiImage else { return }
        isLoading = true
        
        viewModel.sendMessage(query: question, uiImage: uiImage) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if isLoading {
                        self.responseText = response
                        let result = ScanExpenseResult.fromJson(jsonString: response)
                        if (result != nil) {
                            self.expenseResult = result!
                        }
                    }
                    print("SUCCESS!!!!")
                    print(expenseResult)
                    cancelVisionAI()
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    cancelVisionAI()
                }
            }
        }
    }
    
    func cancelVisionAI() {
        DispatchQueue.main.async {
            isLoading = false
            isShowingPhotoLibrary = false
            isShowingCamera = false
            isShowingActionSheet = false
        }
    }
}

struct CustomBottomSheet: View {
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
