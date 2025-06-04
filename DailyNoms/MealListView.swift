//
//  MealListView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 31.05.25.
//

import SwiftUI
import SwiftData

struct MealListView: View {
    @Query var meals: [Meal]
    

    var body: some View {
        NavigationStack {
            List(meals) { meal in
                    if let dish = meal.dishes.first {
                        NavigationLink(destination: DishDetailView(dish: dish)) {
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

#Preview {
    MealListView()
}
