//
//  ScanExpenseViewModel.swift
//  VisionAI
//
//  Created by Arya Adyatma on 12/06/24.
//
import SwiftUI
import Combine

class ScanExpenseViewModel: ObservableObject {
    @Published var isShowingCamera = false
    @Published var isShowingPhotoLibrary = false
    @Published var image: Image? = nil
    @Published var responseText: String = ""
    @Published var isLoading = false
    @Published var question: String = "Scan this bill. Categories: \(TransactionCategory.getCategoryNames()). Do not use categories other than this."
    @Published var shouldNavigateNext = false
    @Published var isShowingActionSheet = false
    @Published var uiImage: UIImage? = nil
    @Published var expenseResult: ScanExpenseResult = ScanExpenseResult.getExample()
    
    private var cancellables = Set<AnyCancellable>()
    
    let aiService: AIService
    
    init() {
        self.aiService = AIService(
            identifier: FakeAPIKey.expenseScanner.rawValue,
            useStreaming: false,
            isConversation: false
        )
        
        $expenseResult
            .sink { [weak self] result in
                self?.shouldNavigateNext = true
                print("SHOULD NAVIGATE!! by didSet")
            }
            .store(in: &cancellables)
    }
    
    func askVisionAI() {
        
        // For testing purposes. Comment or uncomment these three lines.
//        self.expenseResult = ScanExpenseResult.getFromAIResponse()
//        cancelVisionAI()
//        return
        
        guard let uiImage = uiImage else { return }
        isLoading = true
        
        aiService.sendMessage(query: question, uiImage: uiImage) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if self?.isLoading == true {
                        self?.responseText = response
                        if let result = ScanExpenseResult.fromJson(jsonString: response) {
                            self?.expenseResult = result
                        }
                    }
                    print("SUCCESS!!!!")
                    print(self?.expenseResult ?? "No result")
                    self?.cancelVisionAI()
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self?.cancelVisionAI()
                }
            }
        }
    }
    
    func cancelVisionAI() {
        isLoading = false
        isShowingPhotoLibrary = false
        isShowingCamera = false
        isShowingActionSheet = false
    }
}
