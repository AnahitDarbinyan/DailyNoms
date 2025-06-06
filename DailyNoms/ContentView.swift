//
//  ContentView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 27.05.25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Query var users: [User]
    @Query var dishes: [Dish]
    @AppStorage("seedImported") var seedImported: Bool = false

    var user: User? { users.first }
    @Environment(\.modelContext) var modelContext: ModelContext
    @State var splashscreen = true

    func loadSeed() {
        if !seedImported {
            if let fileURL = Bundle.main.url(forResource: "dishes", withExtension: "csv") {
                if let fileContents = try? String(contentsOf: fileURL, encoding: .utf8) {
                    let lines = fileContents.split(separator: "\n")
                    for line in lines {
                        let entry = line.split(separator: ",")
                        if entry.count == 2 {
                            let name = String(entry[0])
                            let calories = Int(String(entry[1]).trimmingCharacters(in: .whitespaces))!

                            let dish = Dish(name: name, calories: calories)
                            modelContext.insert(dish)
                        }
                    }
                }
            }
            try? modelContext.save()
            seedImported = true
        }
    }

    var body: some View {
        if splashscreen {
            SplashScreenView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        splashscreen = false
                    }
                    loadSeed()
//                    modelContext.delete(user!)
//                    try? modelContext.save()
                }
        } else {
            if user != nil {
                NavigationStack {
                    TabView {
                        Tab("Home", systemImage: "house") {
                            HomeView()
                        }
                        Tab("Meals", systemImage: "fork.knife") {
                            MealListView()
                        }
                        Tab("Statistics", systemImage: "chart.xyaxis.line") {
                            WeeklyStatisticsView()
                        }
                        Tab("Settings", systemImage: "person.fill") {
                            SettingsView()
                        }
                    }
                }
            } else {
                UserInfoFormView()
            }
        }
    }
}

#Preview {
    ContentView()
}
