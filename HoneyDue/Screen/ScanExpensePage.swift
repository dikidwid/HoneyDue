//
//  ScanBillPage.swift
//  VisionAI
//
//  Created by Arya Adyatma on 12/06/24.
//

import SwiftUI

struct ScanExpensePage: View {
    @State private var isShowingCamera = false
    @State private var isShowingPhotoLibrary = false
    @State private var image: Image? = nil
    @State private var uiImage: UIImage? = nil
    @State private var responseText: String = ""
    @State private var isLoading = false
    @State private var question: String = "Scan this."
    @State private var expenses: [ScanExpenseItem] = []
    @State private var navigateToBillResults = false
    
    @ObservedObject var viewModel = LLMService(
        identifier: FakeAPIKey.expenseScanner.rawValue,
        useStreaming: false,
        isConversation: false
    )
    
    var body: some View {
        Group {
//            NavigationLink(destination: ScanExpenseResultPage(expenses: expenses), isActive: $navigateToBillResults) {
//                EmptyView()
//            }
            VStack {
                ZStack {
                    Circle()
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
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
                            isShowingCamera = true
                        }) {
                            Text("Take Photo")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            isShowingPhotoLibrary = true
                        }) {
                            Text("Select Photo")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }

                if isLoading {
                    ProgressView()
                        .padding()
                }
                ScrollView {
                    Text(responseText)
                        .background(.gray.opacity(0.1))
                }
                
            }
            .padding()
            .sheet(isPresented: $isShowingCamera) {
                CameraView(isShowingCamera: $isShowingCamera, image: $image, uiImage: $uiImage)
            }
            .sheet(isPresented: $isShowingPhotoLibrary) {
                ImagePicker(image: $image, uiImage: $uiImage)
            }
            .onChange(of: uiImage) {
                askVisionAI()
            }
            .onChange(of: expenses) {
                navigateToBillResults = true
            }
        }
    }
    
    func askVisionAI() {
        guard let uiImage = uiImage else { return }
        isLoading = true
        
        viewModel.sendMessage(query: question, uiImage: uiImage) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.responseText = response
                    expenses = ScanExpenseItem.fromJsonArray(jsonString: response)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
}


#Preview {
    ScanExpensePage()
}
