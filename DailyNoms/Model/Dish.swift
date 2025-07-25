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
    enum ServingType: String, CaseIterable, Codable {
        case slice
        case bowl
        case plate
        case pack
        case quantity
        case glass
    }

    @Attribute(.unique) public var id: UUID = UUID()
    var name: String
    @Attribute(.externalStorage) var image: Data?
    @Attribute var saved: Bool = false
    var calories: Int
    var user: User?
    var favorite: Bool = false
    @Attribute var createdByUser: Bool = false
    var fat: Double
    var saturatedFat: Double?
    var cholesterol: Double?
    var sodium: Double?
    var carbs: Double
    var fiber: Double?
    var sugar: Double?
    var protein: Double
    var vitamins: [String: Double]? = nil
    var minerals: [String: Double]? = nil
    var servingSize: Double // in grams per serving
    var servingType: ServingType = ServingType.plate
    var dishServings: [DishServing] = []

    init(name: String, calories: Int, user: User? = nil, fat: Double, saturatedFat: Double? = nil, cholesterol: Double? = nil, sodium: Double? = nil, carbs: Double, fiber: Double? = nil, sugar: Double? = nil, protein: Double, vitamins: [String: Double]? = nil, minerals: [String: Double]? = nil, servingSize: Double = 100.0, servingType: ServingType = .plate, dishServings: [DishServing] = []) {
        self.name = name
        image = nil
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
        self.servingType = servingType
        self.dishServings = dishServings
    }
}
