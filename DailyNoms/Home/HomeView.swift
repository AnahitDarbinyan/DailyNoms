//
//  HomeView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 22.05.25.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    @Query var users: [User]
    @State var date = Date()

    var user: User {
        if let first = users.first {
            return first
        } else {
            let newUser = User(name: "Preview", age: 25, gender: .female)
            return newUser
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Welcome, \(user.name)!")
                .padding(.top, 20)
                .font(.largeTitle)
                .foregroundStyle(Color.white)

            VStack(spacing: 30) {
                HStack {
                    Button {
                        date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
                    } label: {
                        Image(systemName: "chevron.left")
                            .offset(x: 15, y: 10)
                    }

                    HStack {
                        Text(date.relative)
                            .font(.subheadline)
                        Image(systemName: "calendar")
                    }
                    .frame(maxWidth: .infinity)

                    Button {
                        date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                    } label: {
                        Image(systemName: "chevron.right")
                            .offset(x: -15, y: 10)
                    }
                }

                HomeStatsView(date: date)
                    .padding(.horizontal, 20)
            }

            .padding(.vertical, 30)
            .background(Color(.widgetBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

            MealCategoryView(date: date)
                .frame(maxHeight: .infinity)
                .background(Color(.widgetBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .padding(.horizontal, 20)
        .background(alignment: .top) {
            Rectangle()
                .fill(LinearGradient(colors: [.blue, .white], startPoint: .top, endPoint: .bottom))
                .frame(maxWidth: .infinity, minHeight: 300, maxHeight: 300)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .modelContainer(for: User.self)
}
