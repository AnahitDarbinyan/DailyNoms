//
//  User.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 27.05.25.
//

/*
User
 │
 ├───▶ Meal ───▶ Dish
 │
 ├───▶ MealReminder
 │
 └───▶ Snapshot(weight, height, activity)
*/

import Foundation
import SwiftData

@Model
class User {
    enum Gender: String, CaseIterable,  Codable {
        case male
        case female
    }

    @Attribute(.unique) var name: String
    var age: Int
    var gender: Gender

    
    @Relationship var mealEntries: [Meal] = []
    @Relationship var mealReminders: [MealReminder] = []
    @Relationship(inverse: \Snapshot.user) var snapshots: [Snapshot] = []
    var snapshot: Snapshot{ snapshots.sorted{$0.date > $1.date}.first!}
    
    init(name: String, age: Int, gender: Gender) {
        self.name = name
        self.age = age
        self.gender = gender
    }
}
