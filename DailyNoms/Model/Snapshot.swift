//
//  Snapshot.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 28.05.25.
//

import Foundation
import SwiftData

@Model
class Snapshot: Identifiable {
    enum ActivityLevel: String, CaseIterable, Codable {
        case sedentary
        case lightlyActive
        case moderatelyActive
        case veryActive
        case extraActive
    }
    var weight: Double
    var height: Double
    var activityLevel: ActivityLevel
    @Attribute(.unique) var date: Date = Date()
    
    var user: User?

    init(weight: Double, height: Double, activityLevel: ActivityLevel = .sedentary, user: User?) {
        self.weight = weight
        self.height = height
        self.user = user
        self.activityLevel = activityLevel
    }
}
