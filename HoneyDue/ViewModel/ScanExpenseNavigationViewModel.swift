//
//  ScanExpenseNavigationViewModel.swift
//  HoneyDue
//
//  Created by Arya Adyatma on 24/06/24.
//

import Foundation
import SwiftUI

class ScanExpenseNavigationViewModel: ObservableObject {
    @Published var shouldGoBack: Bool = false
    @Published var path = NavigationPath()
    var presentationMode: PresentationMode?
    var dismiss: DismissAction?
}
