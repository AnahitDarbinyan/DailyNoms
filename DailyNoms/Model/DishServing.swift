//
//  DishServing.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 16.06.25.
//

import Foundation
import SwiftData

@Model
class DishServing {
    public var id: UUID = UUID()
    public var dish: Dish
    public var servings: Double
    public var servingSize: Double? // in grams
    public var meal: Meal?

    init(dish: Dish, servings: Double, servingSize: Double? = nil, meal: Meal? = nil) {
        self.dish = dish
        self.servings = servings
        self.servingSize = servingSize
        self.meal = meal
    }

    var calories: Int {
        return Int(ratio * Double(dish.calories))
    }

    var ratio: Double {
        return ((servingSize ?? dish.servingSize) * servings) / 100
    }

    var protein: Double {
        return ratio * Double(dish.protein)
    }

    var fat: Double {
        return ratio * Double(dish.fat)
    }

    var carbs: Double {
        return ratio * Double(dish.carbs)
    }
}
