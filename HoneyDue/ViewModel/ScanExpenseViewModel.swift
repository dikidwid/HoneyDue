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
    @Published var isScanning = false
    @Published var question: String = "Scan this bill. Categories: \(TransactionCategory.getCategoryNames()). Do not use categories other than this."
    @Published var shouldNavigateNext = false
    @Published var isShowingActionSheet = false
    @Published var uiImage: UIImage? = nil
    @Published var expenseResult: ScanExpenseResult = ScanExpenseResult.getExample()
    
    @Published var customNotification: Notification = .failScanBill
    @Published var isShowCustomNotification: Bool = false
    
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
            }
            .store(in: &cancellables)
    }
    
    func askVisionAI() {
        
        // For testing purposes. Comment or uncomment these three lines.
//        self.expenseResult = ScanExpenseResult.getFromAIResponse()
//        self.closeOverlay()
//        return
        
        guard let uiImage = uiImage else { return }
        isScanning = true
        
        aiService.sendMessage(query: question, uiImage: uiImage) { [weak self] result in
            DispatchQueue.main.async {
                switch result {

                case .success(let response):
                    if self?.isScanning == true {

                        self?.responseText = response
                        
                        if let result = ScanExpenseResult.fromJson(jsonString: response) {
                            print("Scan Bill Return JSON and Success!")
                            self?.expenseResult = result
                        } else {
                            self?.onError()
                        }
                    }
                    print(self?.expenseResult ?? "No result")
                    self?.closeOverlay()
                
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self?.closeOverlay()
                    self?.onError()
                }
            }
        }
    }
    
    func closeOverlay() {
        isScanning = false
        isShowingPhotoLibrary = false
        isShowingCamera = false
        isShowingActionSheet = false
    }
    
    func onError() {
//        customNotification = .failScanBill
        isShowCustomNotification = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.customNotification = .defaultNotification
            self.isShowCustomNotification = false
        }
    }
}
