//
//  SettingsNotificationPage.swift
//  HoneyDue
//
//  Created by Arya Adyatma on 25/06/24.
//
import SwiftUI

struct SettingsNotificationPage: View {
    @ObservedObject var viewModel: SettingsService
    
    var body: some View {
        VStack {
            TopBarBack(title: "Notifications")
                .padding(.horizontal)
            List {
                SettingsToggle(title: "Input transaction reminder", isOn: $viewModel.inputTransactionReminderEnabled)
                
                SettingsToggle(
                    title: "Smart reminder",
                    isOn: $viewModel.smartReminderEnabled,
                    disabled: !viewModel.inputTransactionReminderEnabled
                )
                
                DatePickerRow(
                    title: "Reminder time",
                    date: $viewModel.reminderTime,
                    disabled: !viewModel.inputTransactionReminderEnabled || viewModel.smartReminderEnabled
                )
                .listSectionSeparator(.hidden, edges: .bottom)
            }
            .listStyle(PlainListStyle())
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
}

#Preview {
    SettingsNotificationPage(viewModel: SettingsService())
}
