//
//  DailyNomsApp.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 27.05.25.
//

import SwiftUI
import SwiftData

@main

struct DailyNomsApp: App {

    var body: some Scene {
        WindowGroup{
            ContentView()
                .modelContainer(for: [User.self, Dish.self, Meal.self, MealReminder.self, Snapshot.self])
        }
    }
}


