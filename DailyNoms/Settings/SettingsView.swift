//
//  SettingsView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 02.06.25.
//

import SwiftData
import SwiftUI
import UserNotifications

struct SettingsView: View {
    @AppStorage("notificationsEnabled") var notificationsEnabled: Bool = false
    @Query var users: [User]
    var user: User { users.first! }

    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Image(systemName: "person.circle").resizable()
                        .frame(width: 50, height: 50)
                    VStack {
                        Text(user.name).font(.title2)
                    }
                }
                Section(header: Text("Account")) {
                    NavigationLink("Edit Profile") {
                        EditProfileView()
                    }
                }
                Section(header: Text("Notifications")) {
                    Toggle("Daily Reminder", isOn: $notificationsEnabled)
                        .onChange(of: notificationsEnabled) { value in
                            if value {
                                NotificationsManager.shared.requestAuthorization()
                                NotificationsManager.shared.scheduleNotification(caloriesRemaining: 0)
                            } else {
                                NotificationsManager.shared.cancelAllNotifications()
                            }
                        }
                }
                Section {
                    NavigationLink {
                        DishLibraryView()
                    } label: {
                        Label("Library", systemImage: "book.fill")
                    }
                    .navigationTitle("Settings")
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
