//
//  SettingsPage.swift
//  HoneyDue
//
//  Created by Arya Adyatma on 25/06/24.
//

import SwiftUI

struct SettingsPage: View {
    @EnvironmentObject var userService: UserService
    @StateObject private var settingsService = ConfigService()
    
    var body: some View {
        VStack {
            TopBarBack(title: "Settings")
                .padding(.horizontal)
            List {
                NavigationLink(destination: SettingsNotificationPage(settingsService: settingsService)) {
                    SettingsRow(title: "Notifications")
                }
                
                SettingsToggle(title: "Idle mode", isOn: Binding(
                    get: { settingsService.idleModeEnabled },
                    set: { settingsService.updateIdleModeEnabled($0) }
                ))
                
                Button(action: {
                    userService.logout()
                }) {
                    SettingsRow(title: "Log out")
                }
                .listSectionSeparator(.hidden, edges: .bottom)
            }
            .listStyle(PlainListStyle())
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        SettingsPage()
            .environmentObject(UserService())
    }
}
