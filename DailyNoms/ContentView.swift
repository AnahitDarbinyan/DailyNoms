//
//  ContentView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 27.05.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query var users: [User]
    @Query var dishes: [Dish]
    

    var user: User?{users.first}
    @Environment(\.modelContext) var modelContext: ModelContext
    @State var splashscreen = true
    
    var body: some View {
        if splashscreen{
            SplashScreenView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                        splashscreen = false
                    })
//                    modelContext.delete(user!)
//                    try? modelContext.save()
                }
        }else {
            if let user{
                TabView {
                    Tab("Home", systemImage: "house")
                    {
                        HomeView()
                    }
                    Tab("Meals", systemImage: "fork.knife")
                    {
                        MealListView()
                    }
                    Tab("Statistics", systemImage: "chart.xyaxis.line")
                    {
                        WeeklyStatisticsView()
                    }
                    Tab("Settings", systemImage: "person.fill")
                    {
                        SettingsView()
                    }
                }
            }else{
                UserInfoFormView()
            }
        }
    
    }
}

#Preview {
    ContentView()
}
