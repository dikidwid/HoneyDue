//
//  ScanExpenseNavigationViewModel.swift
//  HoneyDue
//
//  Created by Arya Adyatma on 24/06/24.
//

import Foundation
import SwiftUI

class ScanExpenseNavigationViewModel: ObservableObject {
    @Published var path = NavigationPath() {
        didSet {
            print("Navigation path updated: \(path)")
        }
    }
}
