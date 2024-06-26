//
//  Notification.swift
//  iTrack
//
//  Created by Diki Dwi Diro on 25/06/24.
//

import SwiftUI

struct Notification {
    let title: String
    let message: String
    let status: Status
    
    enum Status {
        case Success
        case Fail
        
        var icon: String {
            switch self {
            case .Success:
                return "checkmark.circle.fill"
            case .Fail:
                return "xmark.circle.fill"
            }
        }
        
        var foreground: Color {
            switch self {
            case .Success:
                return .successForeground
            case .Fail:
                return .failForeground
            }
        }
        
        var background: Color {
            switch self {
            case .Success:
                return .successBackground
            case .Fail:
                return .failBackground
            }
        }
    }
}

extension Notification {
    static let successAddExpense: Notification = Notification(title: "Expense Added Successfully!",
                                                              message: "Great job! Your expense has been recorded.", 
                                                              status: .Success)
    
    static let successUpdateExpense: Notification = Notification(title: "Expense Updated!",
                                                                 message: "Your changes have been saved successfully.",
                                                                 status: .Success)
    
    static let failAddExpense: Notification = Notification(title: "Failed to Add Expense",
                                                           message: "Failed to add expense. Please try again.", 
                                                           status: .Fail)
    
    static let successEnableBudget: Notification = Notification(title: "Budget Enabled!",
                                                                message: "Your budget changes have been saved successfully.",
                                                                status: .Success)
    
    static let successUpdateBudget: Notification = Notification(title: "Budget Updated!",
                                                                message: "Your budget changes have been saved successfully.", 
                                                                status: .Success)
    
    static let failScanBill: Notification = Notification(title: "Scan Error",
                                                         message: "Unable to scan the bill. Please try again.",
                                                         status: .Fail)
    
    static let networkError: Notification = Notification(title: "Network Error",
                                                         message: "Please check your connection and try again.",
                                                         status: .Fail)
    
    static let defaultNotification: Notification = Notification(title: "", message: "", status: .Fail)
}
