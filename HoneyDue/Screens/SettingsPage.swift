//
//  SettingsPage.swift
//  HoneyDue
//
//  Created by Arya Adyatma on 25/06/24.
//
import SwiftUI

struct SettingsPage: View {
    @EnvironmentObject var userService: UserService
    @StateObject private var viewModel = SettingsService()
    
    var body: some View {
        VStack {
            TopBarBack(title: "Settings")
                .padding(.horizontal)
            List {
                NavigationLink(destination: SettingsNotificationPage(viewModel: viewModel)) {
                    SettingsRow(title: "Notifications")
                }
                
                SettingsToggle(title: "Idle mode", isOn: $viewModel.idleModeEnabled)
                
                NavigationLink(destination: Text("Logged out!")) {
                    SettingsRow(title: "Log out")
                }
                .listSectionSeparator(.hidden, edges: .bottom)
                .onTapGesture {
                    userService.logout()
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        SettingsPage()
    }
}
