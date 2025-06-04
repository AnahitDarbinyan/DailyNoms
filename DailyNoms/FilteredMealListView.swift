//
//  FilteredMealListView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 04.06.25.
//

import SwiftUI

import SwiftUI
import SwiftData

struct FilteredMealListView: View {
    var kind: Meal.Kind

    @Query var allMeals: [Meal]

    var filteredMeals: [Meal] {
        allMeals.filter { $0.mealtype == kind }
    }

    var body: some View {
        List {
            ForEach(filteredMeals) { meal in
                Section(header: Text(meal.date.formatted(date: .abbreviated, time: .omitted))) {
                    ForEach(meal.dishes) { dish in
                        VStack(alignment: .leading) {
                            Text(dish.name)
                                .font(.headline)
                            Text("\(dish.calories) kcal")
                                .font(.subheadline)
                        }
                    }
                }
            }
        }
        .navigationTitle(kind.rawValue.capitalized)
    }
}
#Preview {
    FilteredMealListView(kind: .breakfast)
}


