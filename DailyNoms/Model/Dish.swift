//
//  Dish.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 27.05.25.
//

import Foundation
import SwiftData

@Model
public class Dish: Identifiable {

    @Attribute(.unique) public var id: UUID = UUID()
    var name: String
    var calories: Int
    var user: User?

    var fat: Double?
    var saturatedFat: Double?
    var cholesterol: Double?
    var sodium: Double?
    var carbs: Double?
    var fiber: Double?
    var sugar: Double?
    var protein: Double?
    var vitamins: [String: Double]?
    var minerals: [String: Double]?
    var servingSize: String?
    
    var mealEntries: [Meal] = []

    init(id: UUID, name: String, calories: Int, user: User? = nil, fat: Double? = nil, saturatedFat: Double? = nil, cholesterol: Double? = nil, sodium: Double? = nil, carbs: Double? = nil, fiber: Double? = nil, sugar: Double? = nil, protein: Double? = nil, vitamins: [String : Double]? = nil, minerals: [String : Double]? = nil, servingSize: String? = nil, mealEntries: [Meal]) {
        self.id = id
        self.name = name
        self.calories = calories
        self.user = user
        self.fat = fat
        self.saturatedFat = saturatedFat
        self.cholesterol = cholesterol
        self.sodium = sodium
        self.carbs = carbs
        self.fiber = fiber
        self.sugar = sugar
        self.protein = protein
        self.vitamins = vitamins
        self.minerals = minerals
        self.servingSize = servingSize
        self.mealEntries = mealEntries
    }
}

