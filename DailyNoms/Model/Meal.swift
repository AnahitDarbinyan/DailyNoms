//
//  MealEntry.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 27.05.25.
//

import Foundation
import SwiftData


@Model
class Meal : Identifiable{
    enum Kind: String, CaseIterable, Codable {
        case breakfast = "Breakfast"
        case lunch = "Lunch"
        case dinner = "Dinner"
        case snack = "Snack"
    }
    
    @Attribute(.unique) var id = UUID()
    var date = Date()
    var calories: Int {dishes.reduce(0){$0 + $1.calories}}
    
    var dishes: [Dish] = []
    var user: User?
    var mealtype: Kind
    
    
    var totalProtein: Double {
        dishes.reduce(0) { $0 + ($1.protein ?? 0) }
    }
    
    var totalFat: Double {
        dishes.reduce(0) { $0 + ($1.fat ?? 0) }
    }
    
    var totalCarbs: Double {
        dishes.reduce(0) { $0 + ($1.carbs ?? 0) }
    }
    
    init(mealtype: Kind = .breakfast, dishes: [Dish], user: User?) {
        self.dishes = dishes
        self.user = user
        self.mealtype = mealtype
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
}
