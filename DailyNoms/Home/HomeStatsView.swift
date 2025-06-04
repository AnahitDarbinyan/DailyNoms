//
//  HomeStatsView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 04.06.25.
//

import SwiftData
import SwiftUI

struct HomeStatsView: View {
    @Query var meals: [Meal]
    @Query var users: [User]
    var date: Date

    var user: User {
        if let first = users.first {
            return first
        } else {
            let newUser = User(name: "Preview", age: 25, gender: .female)
            return newUser
        }
    }

    var expectedCalories: Int {
        let weight = Double(user.snapshot.weight)
        let height = Double(user.snapshot.height)
        let age = Double(user.age)
        let gender = user.gender
        var bmr: Double

        if gender.rawValue == "male" {
            bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5
        } else {
            bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161
        }

        return Int(bmr)
    }

    var caloriesEaten: Int {
        meals.reduce(0) { $0 + $1.calories }
    }

    var caloriesRemaining: Int {
        expectedCalories - caloriesEaten
    }

    var totalProtein: Double {
        meals.reduce(0) { total, meal in
            total + meal.dishes.reduce(0) { $0 + ($1.protein ?? 0) }
        }
    }

    var totalFat: Double {
        meals.reduce(0) { total, meal in
            total + meal.dishes.reduce(0) { $0 + ($1.fat ?? 0) }
        }
    }

    var totalCarbs: Double {
        meals.reduce(0) { total, meal in
            total + meal.dishes.reduce(0) { $0 + ($1.carbs ?? 0) }
        }
    }

    init(date: Date) {
        self.date = date
        _meals = Query(filter: Meal.at(date: date))
    }

    var body: some View {
        CalorieProgressView(remaining: caloriesRemaining, current: caloriesEaten)

        HStack(spacing: 0) {
            ComponentView(title: "Protein", current: Int(totalProtein), total: 10, color: .orange)
                .frame(minWidth: 50, maxWidth: .infinity)
            ComponentView(title: "Carbs", current: Int(totalCarbs), total: 10, color: .teal)
                .frame(minWidth: 50, maxWidth: .infinity)
            ComponentView(title: "Fat", current: Int(totalFat), total: 10, color: .red)
                .frame(minWidth: 50, maxWidth: .infinity)
        }
    }
}

#Preview {
    HomeStatsView(date: Date())
}
