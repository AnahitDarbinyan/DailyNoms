//
//  HomeView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 22.05.25.
//

// import SwiftData
// import SwiftUI
//
// struct HomeView: View {
//    @Query var users: [User]
//    @State var date = Date()
//
//    var user: User {
//        if let first = users.first {
//            return first
//        } else {
//            let newUser = User(name: "Preview", age: 25, gender: .female)
//            return newUser
//        }
//    }
//
//    var body: some View {
//        NavigationStack {
//            VStack(alignment: .leading) {
//                Text("Welcome, \(user.name)!")
//                    .padding(.top)
//                    .font(.largeTitle)
//                    .foregroundStyle(Color.white)
//                    .offset(y: 20)
//
//                VStack(spacing: 30) {
//                    HStack {
//                        Button {
//                            date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
//                        } label: {
//                            Image(systemName: "chevron.left")
//                                .offset(x: 15, y: 10)
//                                .foregroundColor(Color("MidnightPurple"))
//                        }
//
//                        HStack {
//                            Text(date.relative)
//                                .font(.subheadline)
//                                .foregroundColor(Color("MidnightPurple"))
//                            Image(systemName: "calendar")
//                        }.offset(y: 10)
//                            .frame(maxWidth: .infinity)
//                            .foregroundColor(Color("MidnightPurple"))
//
//                        Button {
//                            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
//                        } label: {
//                            Image(systemName: "chevron.right")
//                                .offset(x: -15, y: 10)
//                                .foregroundColor(Color("MidnightPurple"))
//                        }
//                    }
//
//                    HomeStatsView(date: date)
//                        .padding(.horizontal, 20)
//                }
//                .offset(y: -10)
//                .padding(.vertical, 20)
//                .background(Color(.widgetBackground))
//                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
//
//                MealCategoryView(date: date)
//                    .frame(maxHeight: .infinity)
//                    .background(Color(.widgetBackground))
//                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
//                    .offset(y: 0)
//                    .frame(height: 320)
//
//            }.offset(y: -40)
//                .padding(.horizontal, 20)
//                .background(alignment: .top) {
//                    Rectangle()
//                        .fill(LinearGradient(colors: [Color("MidnightPurple"), .white], startPoint: .top, endPoint: .bottom))
//                        .frame(maxWidth: .infinity, minHeight: 300, maxHeight: 300)
//                        .ignoresSafeArea()
//                }
//                .navigationBarItems(trailing:
//                    NavigationLink(destination: NotificationsListView()) {
//                        Image(systemName: "bell.circle.fill")
//                            .font(.system(size: 25, weight: .bold))
//                            .foregroundColor(.white)
//                            .padding(6)
//                    }
//                )
//        }
//    }
// }
//
// #Preview {
//    NavigationStack {
//        HomeView()
//    }
//    .modelContainer(for: User.self)
// }

import SwiftData
import SwiftUI

struct HomeView: View {
    @Query var users: [User]
    @State private var date = Date()

    var user: User {
        if let first = users.first {
            return first
        } else {
            let newUser = User(name: "Anul", age: 25, gender: .female)
            return newUser
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    WelcomeSection(user: user)
                    CalendarSection(date: $date)
                    CalorieTrackerSection(date: date)
                    MealCategorySection(date: date)
                }
                .padding(.horizontal, 10)
            }

            .navigationBarItems(trailing:
                NavigationLink(destination: NotificationsListView()) {
                    Image(systemName: "bell.circle.fill")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.white)
                        .background(Circle().fill(Color("Calories").opacity(0.7)))
                        .frame(width: 40, height: 40)
                }
            )
        }
    }
}

struct WelcomeSection: View {
    let user: User

    var body: some View {
        Text("Welcome, name!")
            .padding(.top, -40)
            .font(Font.custom("Futura", size: 36).weight(.bold))
            .foregroundStyle(Color("Calories"))
            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
    }
}

struct CalendarSection: View {
    @Binding var date: Date

    var body: some View {
        CalendarView(date: $date)
            .padding(.vertical, 10)
            .background(Color(.widgetBackground).opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct CalorieTrackerSection: View {
    let date: Date

    var body: some View {
        VStack(spacing: 30) {
            HomeStatsView(date: date)
                .padding(.horizontal, 25)
        }
        .offset(y: 0)
        .padding(.vertical, 25)
        .frame(minHeight: 200)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground).opacity(0.9))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(.systemGray4), lineWidth: 0.5)
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct MealCategorySection: View {
    let date: Date

    var body: some View {
        MealCategoryView(date: date)
            .frame(maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground).opacity(0.9))
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(.systemGray4), lineWidth: 0.5)
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .modelContainer(for: User.self)
}
