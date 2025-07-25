//
//  Meal.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 27.05.25.
//

import Foundation
import SwiftData

@Model
class Meal: Identifiable {
    enum Kind: String, CaseIterable, Codable {
        case breakfast = "Breakfast"
        case lunch = "Lunch"
        case dinner = "Dinner"
        case snack = "Snack"
    }

    @Attribute(.unique) var id = UUID()
    var date: Date
    var timestamp: Date

    var calories: Int { dishServings.reduce(0) { $0 + $1.calories }}

    var dishServings: [DishServing] = []

    var user: User?
    var mealtype: Kind

    var totalProtein: Double {
        dishServings.reduce(0) { $0 + ($1.protein) }
    }

    var totalFat: Double {
        dishServings.reduce(0) { $0 + ($1.fat) }
    }

    var totalCarbs: Double {
        dishServings.reduce(0) { $0 + ($1.carbs) }
    }

    init(mealtype: Kind = .breakfast, dishServings: [DishServing], user: User?) {
        self.dishServings = dishServings
        self.user = user
        self.mealtype = mealtype
        timestamp = Date()
        date = Date()
    }
}

extension Meal {
    static func sinceMorning() -> Predicate<Meal> {
        let morning = Date.morning

        return #Predicate<Meal> {
            $0.date > morning
        }
    }

    static func last(days: Int) -> Predicate<Meal> {
        let morning = Date.morning
        let last = Calendar.current.date(byAdding: .day, value: -days, to: morning)!
        return #Predicate<Meal> {
            $0.date > last
        }
    }

    static func at(date: Date) -> Predicate<Meal> {
        let morning = date.morning
        let next = Calendar.current.date(byAdding: .day, value: 1, to: morning)!

        return #Predicate<Meal> {
            $0.date > morning && $0.date < next
        }
    }
}
