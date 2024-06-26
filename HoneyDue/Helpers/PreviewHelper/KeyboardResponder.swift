//
//  KeyboardResponder.swift
//  HoneyDue
//
//  Created by Fristania Verenita on 26/06/24.
//

import SwiftUI
import Combine

final class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .compactMap { notification -> CGFloat? in
                guard let userInfo = notification.userInfo,
                      let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                    return nil
                }
                return endFrame.height
            }
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification).map { _ in CGFloat(0) })
            .assign(to: \.currentHeight, on: self)
    }
    
    deinit {
        cancellable?.cancel()
    }
}

