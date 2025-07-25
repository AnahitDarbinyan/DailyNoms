//
//  ContentView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 27.05.25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Query var users: [User]
    @Query var dishes: [Dish]
    @AppStorage("seedImported") var seedImported: Bool = false
    @Environment(\.modelContext) var modelContext
    @State var splashscreen = true

    var user: User? { users.first }

    func loadSeed() {
        guard !seedImported else { return }
        dishes.forEach { modelContext.delete($0) }

        if let fileURL = Bundle.main.url(forResource: "dishdetails", withExtension: "csv") {
            do {
                let fileContents = try String(contentsOf: fileURL, encoding: .utf8)
                let lines = fileContents.split(separator: "\n").dropFirst()

                for line in lines {
                    func splitCSVLine(_ line: String) -> [String] {
                        var result: [String] = []
                        var current = ""
                        var insideQuotes = false

                        for char in line {
                            if char == "\"" {
                                insideQuotes.toggle()
                            } else if char == "," && !insideQuotes {
                                result.append(current)
                                current = ""
                            } else {
                                current.append(char)
                            }
                        }
                        result.append(current)
                        return result
                    }
                    let entry = splitCSVLine(String(line))

                    if entry.count >= 14 {
                        let name = entry[0].trimmingCharacters(in: .whitespaces)
                        let calories = Int(entry[1].trimmingCharacters(in: .whitespaces)) ?? 0
                        let fat = Double(entry[2].trimmingCharacters(in: .whitespaces)) ?? 0
                        let saturatedFat = Double(entry[3].trimmingCharacters(in: .whitespaces)) ?? 0
                        let cholesterol = Double(entry[4].trimmingCharacters(in: .whitespaces)) ?? 0
                        let sodium = Double(entry[5].trimmingCharacters(in: .whitespaces)) ?? 0
                        let carbs = Double(entry[6].trimmingCharacters(in: .whitespaces)) ?? 0
                        let fiber = Double(entry[7].trimmingCharacters(in: .whitespaces)) ?? 0
                        let sugar = Double(entry[8].trimmingCharacters(in: .whitespaces)) ?? 0
                        let protein = Double(entry[9].trimmingCharacters(in: .whitespaces)) ?? 0

                        let vitamins = entry[10].split(separator: ",").reduce(into: [String: Double]()) { acc, vit in
                            let parts = vit.split(separator: ":")
                            if parts.count == 2 {
                                let key = parts[0].trimmingCharacters(in: .punctuationCharacters)
                                let val = parts[1].trimmingCharacters(in: .punctuationCharacters)
                                acc[key] = Double(val) ?? 0
                            }
                        }

                        let minerals = entry[11].split(separator: ",").reduce(into: [String: Double]()) { acc, min in
                            let parts = min.split(separator: ":")
                            if parts.count == 2 {
                                let key = parts[0].trimmingCharacters(in: .punctuationCharacters)
                                let val = parts[1].trimmingCharacters(in: .punctuationCharacters)
                                acc[key] = Double(val) ?? 0
                            }
                        }

                        let servingSize = Double(entry[12].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 100
                        let servingTypeRaw = entry[13]
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                            .trimmingCharacters(in: .init(charactersIn: "\"\r\n"))
                        let servingType = Dish.ServingType(rawValue: servingTypeRaw.lowercased()) ?? .plate

                        let dish = Dish(
                            name: name,
                            calories: calories,
                            fat: fat,
                            saturatedFat: saturatedFat,
                            cholesterol: cholesterol,
                            sodium: sodium,
                            carbs: carbs,
                            fiber: fiber,
                            sugar: sugar,
                            protein: protein,
                            vitamins: vitamins,
                            minerals: minerals,
                            servingSize: servingSize,
                            servingType: servingType
                        )
                        modelContext.insert(dish)
                    }
                }

                try modelContext.save()
                seedImported = true
            } catch {
                print("Error reading CSV or saving data: \(error)")
            }
        }
    }

    var body: some View {
        if splashscreen {
            SplashScreenView()
                .onAppear {
                    loadSeed()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        splashscreen = false
                    }
                }
        } else {
            if user != nil {
                NavigationStack {
                    TabView {
                        Tab("Home", systemImage: "house") {
                            UserInfoFormView()
                        }
                        Tab("Meals", systemImage: "fork.knife") {
                            MealListView()
                        }
                        Tab("Statistics", systemImage: "chart.xyaxis.line") {
                            WeeklyStatisticsView()
                        }
                        Tab("Settings", systemImage: "person.fill") {
                            SettingsView()
                        }
                    }
                }
            } else {
                UserInfoFormView()
            }
        }
    }
}

#Preview {
    ContentView()
}
