//
//  SettingsNotificationPage.swift
//  HoneyDue
//
//  Created by Arya Adyatma on 25/06/24.
//
import SwiftUI

struct SettingsNotificationPage: View {
    @ObservedObject var settingsService: ConfigService
    
    var body: some View {
        VStack {
            TopBarBack(title: "Notifications")
                .padding(.horizontal)
            List {
                SettingsToggle(
                    title: "Input transaction reminder",
                    isOn: Binding(
                        get: { settingsService.inputTransactionReminderEnabled },
                        set: { settingsService.updateInputTransactionReminderEnabled($0) }
                    )
                )
                
                SettingsToggle(
                    title: "Smart reminder",
                    isOn: Binding(
                        get: { settingsService.smartReminderEnabled },
                        set: { settingsService.updateSmartReminderEnabled($0) }
                    ),
                    disabled: !settingsService.inputTransactionReminderEnabled
                )
                
                DatePickerRow(
                    title: "Reminder time",
                    date: Binding(
                        get: { settingsService.reminderTime },
                        set: { settingsService.updateReminderTime($0) }
                    ),
                    disabled: !settingsService.inputTransactionReminderEnabled || settingsService.smartReminderEnabled
                )
                .listSectionSeparator(.hidden, edges: .bottom)
            }
            .listStyle(PlainListStyle())
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SettingsNotificationPage(settingsService: ConfigService())
}
