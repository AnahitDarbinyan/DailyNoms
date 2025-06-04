//
//  WeeklyStatisticsView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 02.06.25.
//

import SwiftUI
import Charts
import SwiftData

struct WeeklyStatisticsView: View {
    @Query(filter: Meal.last(days: 7), sort: \.date) var meals: [Meal]
    
    var days: [Date]{
        var days = [Date]()
        for i in 0..<7{
            let date = Calendar.current.date(byAdding: .day, value: -i, to: Date.morning)!
            days.append(date)
        }
        return days.reversed()
    }
    
    var data: [DayCalories]{
        days.enumerated().map{ (i, date) in
           
            
            let calories = meals.filter{ meal in
                
                if let next = days[safe: i + 1] {
                    meal.date >= date && meal.date < next
                } else {
                    meal.date >= date
                }
            }
            .reduce(0) { $0 + $1.calories }
            return DayCalories(day: date, calories: calories)
        }
    }
    
    var body: some View {
        VStack {
            Text("Weekly Calories")
                .font(.title)
                .padding(.bottom)
            
            Chart {
                ForEach(data) { item in
                    BarMark(
                        x: .value("Day", item.day),
                        y: .value("Calories", item.calories)
                    )
                    .foregroundStyle(Color.blue)
                }
            }
            .frame(height: 300)
        }
        .padding()
    }
}

struct DayCalories: Identifiable {
    let id = UUID()
    let day: Date
    let calories: Int
}

#Preview {
    WeeklyStatisticsView()
}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

//struct ViewWeek: Identifiable {
//    let id = UUID()
//    var date: Date
//    let calories: Int
//}
//
//func generateWeeksStats(from startDate: Date, numberOfWeeks: Int) -> [ViewWeek] {
//    var weeks: [ViewWeek] = []
//    
//    for weekIndex in 0..<numberOfWeeks {
//        let weekStart = Date.weekStartDate(from: startDate, weekIndex: weekIndex)
//        let calories = 0
//        weeks.append(ViewWeek(date: weekStart, calories: calories))
//    }
//    
//    return weeks
//}


//
//extension Date {
//    func startOfWeek(using calendar: Calendar = Calendar.current) -> Date? {
//        calendar.dateInterval(of: .weekOfYear, for: self)?.start
//    }
//    
//    static func weekStartDate(from baseDate: Date, weekIndex: Int) -> Date {
//        let calendar = Calendar.current
//        guard let baseWeekStart = baseDate.startOfWeek() else {
//            return baseDate
//        }
//        return calendar.date(byAdding: .weekOfYear, value: weekIndex, to: baseWeekStart) ?? baseWeekStart
//    }
//    static func from(year: Int, month: Int, day: Int) -> Date {
//        var components = DateComponents()
//        components.year = year
//        components.month = month
//        components.day = day
//        return Calendar.current.date(from: components)!
//    }
//}


