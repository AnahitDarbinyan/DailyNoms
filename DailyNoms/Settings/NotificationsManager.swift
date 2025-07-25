//
//  NotificationsManager.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 09.06.25.
//

import Foundation
import UserNotifications

class NotificationsManager {
    static let shared = NotificationsManager()

    private init() {}

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            print(granted ? "Notifications enabled" : "Notifications disabled")
        }
    }

    func scheduleNotification(caloriesRemaining: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Calorie Reminder"
        content.body = "You have \(caloriesRemaining) calories left to eat today."
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: "dailyCalorieReminder", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    func fetchPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            completion(requests)
        }
    }
}
