//
//  DishDetailedView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 30.05.25.
//

import SwiftUI

struct MealDetailView: View {
    let meal: Meal

    var body: some View {
        
        NavigationStack {
            List(meal.dishes) { dish in
                NavigationLink(destination: DishDetailView(dish: dish)){
                    Text(dish.name)
                }
            }
        }
        
        .navigationTitle("Dish Info")
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    let sampleMeal = Meal(
        mealtype : .breakfast,
        dishes : [], user: nil
    )
    MealDetailView(meal: sampleMeal)
}
