//
//  FilteredMealListView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 04.06.25.
//

// import SwiftData
// import SwiftUI
//
// struct FilteredMealListView: View {
//    var kind: Meal.Kind
//
//    @Query var allMeals: [Meal]
//
//    var filteredMeals: [Meal] {
//        allMeals.filter { $0.mealtype == kind }
//    }
//
//    var body: some View {
//        List {
//            ForEach(filteredMeals) { meal in
//                Section(header: Text(meal.date.formatted(date: .abbreviated, time: .omitted))) {
//                    ForEach(meal.dishes) { dish in
//                        VStack(alignment: .leading) {
//                            Text(dish.name)
//                                .font(.headline)
//                            Text("\(dish.calories) kcal")
//                                .font(.subheadline)
//                        }
//                    }
//                }
//            }
//        }
//        .navigationTitle(kind.rawValue.capitalized)
//    }
// }
//
// #Preview {
//    FilteredMealListView(kind: .breakfast)
// }

import SwiftData
import SwiftUI

struct FilteredMealListView: View {
    var kind: Meal.Kind

    @Query private var allMeals: [Meal]

    private var filteredMeals: [Meal] {
        allMeals.filter { $0.mealtype == kind }
    }

    var body: some View {
        MealListContent(meals: filteredMeals, kind: kind)
    }
}

private struct MealListContent: View {
    let meals: [Meal]
    let kind: Meal.Kind

    var body: some View {
        List {
            ForEach(meals) { meal in
                MealSection(meal: meal)
            }
        }
        .navigationTitle(kind.rawValue.capitalized)
    }
}

private struct MealSection: View {
    let meal: Meal

    var body: some View {
        Section(header: Text(meal.date.formatted(date: .abbreviated, time: .omitted))) {
            ForEach(meal.dishServings) { serving in
                DishServingRow(serving: serving)
            }
        }
    }
}

private struct DishServingRow: View {
    let serving: DishServing

    var body: some View {
        VStack(alignment: .leading) {
            Text(serving.dish.name)
                .font(.headline)
            Text("\(serving.calories) kcal (\(serving.servings) servings)")
                .font(.subheadline)
        }
    }
}

#Preview {
    FilteredMealListView(kind: .breakfast)
}

