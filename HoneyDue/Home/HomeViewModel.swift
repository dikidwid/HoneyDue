//
//  HomeViewModel.swift
//  HoneyDue
//
//  Created by Singgih Tulus Makmud on 24/06/24.
//

import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var shine: Bool = false
    @Published var selectedIcon: Icon? = nil
    @Published var selectedIconEdit: Icon? = nil
    @Published var showModal = false
    @Published var isEditMode = false
    @Published var showEditModal = false
    @Published var icons: [Icon] = Icon.seedIcons()
    @Published var initialIconsState: [Icon] = []
    
    func cancelEditMode() {
        self.icons = self.initialIconsState
        self.isEditMode = false
    }
    
    func toggleEditMode() {
        if isEditMode {
            isEditMode.toggle()
        } else {
            initialIconsState = icons
            isEditMode = true
        }
    }
}
