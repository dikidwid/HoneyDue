//
//  OnboardingService.swift
//  HoneyDue
//
//  Created by Arya Adyatma on 26/06/24.
//

import Foundation


class UserService: ObservableObject {
    @Published var shouldShowOnboarding: Bool = true
    
    init() {
        self.shouldShowOnboarding = UserDefaults.standard.object(forKey: "shouldShowOnboarding") as? Bool ?? true
    }
    
    func setShouldShowOnboarding(_ shouldShow: Bool) {
        UserDefaults.standard.set(shouldShowOnboarding, forKey: "shouldShowOnboarding")
        shouldShowOnboarding = shouldShow
    }
    
    func logout() {
        setShouldShowOnboarding(true)
        // TOOD: Delete user data from SwiftData
    }
}
