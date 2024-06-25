//
//  SettingsViewModel.swift
//  HoneyDue
//
//  Created by Arya Adyatma on 25/06/24.
//
import SwiftUI
import Combine
import UserNotifications

class SettingsViewModel: ObservableObject {
    @Published var idleModeEnabled: Bool {
        didSet {
            UserDefaults.standard.set(idleModeEnabled, forKey: "idleModeEnabled")
        }
    }
    
    @Published var inputTransactionReminderEnabled: Bool {
        didSet {
            UserDefaults.standard.set(inputTransactionReminderEnabled, forKey: "inputTransactionReminderEnabled")
            scheduleOrCancelNotification()
        }
    }
    
    @Published var smartReminderEnabled: Bool {
        didSet {
            UserDefaults.standard.set(smartReminderEnabled, forKey: "smartReminderEnabled")
        }
    }
    
    @Published var reminderTime: Date {
        didSet {
            UserDefaults.standard.set(reminderTime, forKey: "reminderTime")
            scheduleOrCancelNotification()
        }
    }
    
    init() {
        self.idleModeEnabled = UserDefaults.standard.bool(forKey: "idleModeEnabled")
        self.inputTransactionReminderEnabled = UserDefaults.standard.bool(forKey: "inputTransactionReminderEnabled")
        self.smartReminderEnabled = UserDefaults.standard.bool(forKey: "smartReminderEnabled")
        self.reminderTime = UserDefaults.standard.object(forKey: "reminderTime") as? Date ?? Date()
        
        // Request notification permissions
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error)")
            }
        }
    }
    
    private func scheduleOrCancelNotification() {
        if inputTransactionReminderEnabled {
            scheduleNotification()
        } else {
            cancelNotification()
        }
    }
    
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "It's time to input your transactions."
        content.sound = .default
        
        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
        dateComponents.second = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "transactionReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    private func cancelNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["transactionReminder"])
    }
}
