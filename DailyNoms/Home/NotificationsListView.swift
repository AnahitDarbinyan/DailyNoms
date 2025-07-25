//
//  NotificationsListView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 09.06.25.
//

import SwiftUI
import UserNotifications

struct NotificationsListView: View {
    @State private var notifications: [UNNotificationRequest] = []

    var body: some View {
        List(notifications, id: \.identifier) { request in
            VStack(alignment: .leading) {
                Text(request.content.title).font(.headline)
                Text(request.content.body).font(.subheadline)
            }
        }
        .navigationTitle("Scheduled Notifications")
        .onAppear {
            NotificationsManager.shared.fetchPendingNotifications { requsts in
                DispatchQueue.main.async {
                    self.notifications = requsts
                }
            }
        }
    }
}

#Preview {
    NotificationsListView()
}
