//
//  SettingsViewModel.swift
//  HoneyDue
//
//  Created by Arya Adyatma on 25/06/24.
//
import SwiftUI
import Combine
import UserNotifications

class SettingsService: ObservableObject {
    @Published var idleModeEnabled: Bool {
        didSet {
            UserDefaults.standard.set(idleModeEnabled, forKey: "idleModeEnabled")
            scheduleOrCancelNotification()
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
            scheduleOrCancelNotification()
        }
    }
    
    @Published var reminderTime: Date {
        didSet {
            UserDefaults.standard.set(reminderTime, forKey: "reminderTime")
            updateNotification()
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
        cancelAllNotifications()
        if inputTransactionReminderEnabled && !idleModeEnabled {
            if smartReminderEnabled {
                scheduleSmartReminders()
            } else {
                scheduleNotification()
            }
        }
    }
    
    private func updateNotification() {
        cancelAllNotifications()
        if inputTransactionReminderEnabled && !smartReminderEnabled {
            scheduleNotification()
        }
    }
    
    private func scheduleNotification() {
       
        let notifObject = LocalNotificationItem.logExpenseNotifications.randomElement()
        
        let content = UNMutableNotificationContent()
        content.title = notifObject!.title
        content.body = notifObject!.body
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
    
    private func scheduleSmartReminders() {
        
        let notifObject = LocalNotificationItem.logExpenseNotifications.randomElement()
        
        let content = UNMutableNotificationContent()
        content.title = notifObject!.title
        content.body = notifObject!.body
        content.sound = .default
        
        let times = [(9, 0), (13, 0), (19, 0)]
        
        for (hour, minute) in times {
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute
            dateComponents.second = 0
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "transactionReminder-\(hour)-\(minute)", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                }
            }
        }
    }
    
    private func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
