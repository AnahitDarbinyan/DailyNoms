//
//  Time.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 28.05.25.
//

import Foundation

// All Time instances are in UTC0
struct Time: Codable {
    var hour: Int
    var minute: Int
    static var noon = Time(12, 0)

    init(_ hour: Int, _ minute: Int) {
        self.hour = hour
        self.minute = minute
    }
}
