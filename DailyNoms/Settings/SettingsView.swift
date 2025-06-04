//
//  SettingsView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 02.06.25.
//

import SwiftData
import SwiftUI

struct SettingsView: View {
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
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
