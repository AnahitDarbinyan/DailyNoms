//
//  MealDetailView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 30.05.25.
//

import SwiftUI

struct MealDetailView: View {
    let meal: Meal

    var body: some View {
        HStack {
            Text("Total")
            Text("\(meal.calories)")
        }
        List(meal.dishes) { dish in
            NavigationLink(destination: DishDetailView(dish: dish)) {
                Text(dish.name)
                Text("\(dish.calories)")
            }
        }

        .navigationTitle(meal.mealtype.rawValue.capitalized)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let sampleMeal = Meal(
        mealtype: .breakfast,
        dishes: [], user: nil
    )
    MealDetailView(meal: sampleMeal)
}
