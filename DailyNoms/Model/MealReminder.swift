//
//  MealReminder.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 28.05.25.
//

import Foundation
import SwiftData

@Model
class MealReminder{
    @Attribute(.unique) var id: UUID = UUID()
    var mealType: Meal.Kind
    var time: Time
    var isEnabled: Bool
    var user: User
    
    init(id: UUID, mealType: Meal.Kind, time: Time, isEnabled: Bool, user: User) {
        self.mealType = mealType
        self.time = time
        self.isEnabled = isEnabled
        self.user = user
    }
}
