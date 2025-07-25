//
//  MealListView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 31.05.25.
//

import SectionedQuery
import SwiftData
import SwiftUI

struct MealListView: View {
    @SectionedQuery(\.date.morning, sort: [SortDescriptor(\Meal.date, order: .reverse)])
    var meals: SectionedResults<Date, Meal>

    var body: some View {
        NavigationStack {
            List(meals) { section in
                Section(section.id.relative) {
                    let meals = section.sorted { $0.date < $1.date }
                    ForEach(meals) { meal in
                        NavigationLink(destination: MealDetailView(meal: meal)) {
                            VStack(alignment: .leading) {
                                Text(meal.mealtype.rawValue.capitalized)
                                    .font(.headline)
                                Text("\(meal.calories) kcal")
                                    .font(.subheadline)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MealListView()
}
