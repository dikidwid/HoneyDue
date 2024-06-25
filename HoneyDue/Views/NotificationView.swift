//
//  NotifcationView.swift
//  iTrack
//
//  Created by Diki Dwi Diro on 25/06/24.
//

import SwiftUI

struct NotificationView: View {
    let notification: Notification
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.black.opacity(0.01))
            .background(.white)
            .overlay(alignment: .leading) {
                HStack(spacing: 20) {
                    Circle()
                        .foregroundStyle(notification.status.background)
                        .overlay {
                            Image(systemName: notification.status.icon)
                                .background(Circle().fill(.white).frame(width: 15))
                                .foregroundStyle(notification.status.foreground)
                                .font(.system(.headline))
                                
                        }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(notification.title)
                            .font(.system(.footnote, weight: .bold))
                            .foregroundStyle(notification.status.foreground)
                        
                        Text(notification.message)
                            .font(.system(.caption2))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.all, 12)
            }
            .frame(width: 360, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ZStack {
        Color.black
        
        NotificationView(notification: .successUpdateExpense)
            .previewDevice(.none)
        .previewLayout(.sizeThatFits)
    }
}
