//
//  Date+Extensions.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 30.05.25.
//

import Foundation

extension Date {
    static var morning: Date {
        let calendar = Calendar.current
        let now = Date()
        return calendar.date(bySettingHour: 6, minute: 0, second: 0, of: now)!
    }

    var morning: Date {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: 6, minute: 0, second: 0, of: self)!
    }

    var relative: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        formatter.doesRelativeDateFormatting = true
        return formatter.string(from: self)
    }
}
