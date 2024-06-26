import SwiftUI
import Combine
import UserNotifications

class ConfigService: ObservableObject {
    @Published private(set) var shouldShowOnboarding: Bool
    @Published private(set) var idleModeEnabled: Bool
    @Published private(set) var inputTransactionReminderEnabled: Bool
    @Published private(set) var smartReminderEnabled: Bool
    @Published private(set) var reminderTime: Date
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        let defaults = UserDefaults.standard
        self.shouldShowOnboarding = defaults.object(forKey: "shouldShowOnboarding") as? Bool ?? true
        self.idleModeEnabled = defaults.bool(forKey: "idleModeEnabled")
        self.inputTransactionReminderEnabled = defaults.bool(forKey: "inputTransactionReminderEnabled")
        self.smartReminderEnabled = defaults.bool(forKey: "smartReminderEnabled")
        self.reminderTime = defaults.object(forKey: "reminderTime") as? Date ?? Date()
        
        setupPublishers()
        requestNotificationPermissions()
    }
    
    private func setupPublishers() {
        $shouldShowOnboarding
            .dropFirst()
            .sink { [weak self] newValue in
                UserDefaults.standard.set(newValue, forKey: "shouldShowOnboarding")
            }
            .store(in: &cancellables)
        
        $idleModeEnabled
            .dropFirst()
            .sink { [weak self] newValue in
                UserDefaults.standard.set(newValue, forKey: "idleModeEnabled")
                self?.scheduleOrCancelNotification()
            }
            .store(in: &cancellables)
        
        $inputTransactionReminderEnabled
            .dropFirst()
            .sink { [weak self] newValue in
                UserDefaults.standard.set(newValue, forKey: "inputTransactionReminderEnabled")
                self?.scheduleOrCancelNotification()
            }
            .store(in: &cancellables)
        
        $smartReminderEnabled
            .dropFirst()
            .sink { [weak self] newValue in
                UserDefaults.standard.set(newValue, forKey: "smartReminderEnabled")
                self?.scheduleOrCancelNotification()
            }
            .store(in: &cancellables)
        
        $reminderTime
            .dropFirst()
            .sink { [weak self] newValue in
                UserDefaults.standard.set(newValue, forKey: "reminderTime")
                self?.updateNotification()
            }
            .store(in: &cancellables)
    }
    
    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error)")
            }
        }
    }
    
    func updateShouldShowOnboarding(_ newValue: Bool) {
        shouldShowOnboarding = newValue
    }
    
    func updateIdleModeEnabled(_ newValue: Bool) {
        idleModeEnabled = newValue
    }
    
    func updateInputTransactionReminderEnabled(_ newValue: Bool) {
        inputTransactionReminderEnabled = newValue
    }
    
    func updateSmartReminderEnabled(_ newValue: Bool) {
        smartReminderEnabled = newValue
    }
    
    func updateReminderTime(_ newValue: Date) {
        reminderTime = newValue
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
        content.title = notifObject?.title ?? "Reminder"
        content.body = notifObject?.body ?? "Don't forget to log your expenses!"
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
        content.title = notifObject?.title ?? "Reminder"
        content.body = notifObject?.body ?? "Don't forget to log your expenses!"
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
