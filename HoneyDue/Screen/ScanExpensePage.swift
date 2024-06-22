//
//  ScanBillPage.swift
//  VisionAI
//
//  Created by Arya Adyatma on 12/06/24.
//

import SwiftUI
import Combine

struct ScanExpensePage: View {
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
        Group {
            NavigationLink(destination: ScanExpenseValidationPage(expenseResult: expenseResult), isActive: $shouldNavigateNext) {
                EmptyView()
            }
            
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
                    ScrollView {
                        Text(responseText)
                            .background(.gray.opacity(0.1))
                    }
                    
                }
                .padding()
                .actionSheet(isPresented: $isShowingActionSheet) {
                    ActionSheet(title: Text("Add expenses magically using AI by scanning your bills."), buttons: [
                        .default(Text("Photo Library")) {
                            isShowingPhotoLibrary = true
                        },
                        .default(Text("Camera")) {
                            isShowingCamera = true
                        },
                        .cancel()
                    ])
                }
                .sheet(isPresented: $isShowingCamera) {
                    CameraView(isShowingCamera: $isShowingCamera, image: $image, uiImage: $uiImage)
                }
                .sheet(isPresented: $isShowingPhotoLibrary) {
                    ImagePicker(image: $image, uiImage: $uiImage)
                }
                .onChange(of: uiImage) { _ in
                    askVisionAI()
                }
            }
        }
    }
    
    func askVisionAI() {
        //        expenseResult = ScanExpenseResult.getFromAIResponse()
        //        cancelVisionAI()
        //        return
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

#Preview {
    NavigationStack {
        ScanExpensePage()
    }
}
