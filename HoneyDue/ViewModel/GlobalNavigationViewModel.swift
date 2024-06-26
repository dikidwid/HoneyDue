//
//  GlobalNavigationViewModel.swift
//  HoneyDue
//
//  Created by Arya Adyatma on 26/06/24.
//

import SwiftUI
import Combine

class GlobalNavigationViewModel: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigate(to destination: Destination) {
        path.append(destination)
    }
    
    func goHome() {
        path.removeLast(path.count)
        navigate(to: .home)
    }
}

enum Destination: Hashable {
    case onboarding
    case home
}
