//
//  DishDetailView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 30.05.25.
//

import SwiftUI

struct DishDetailView: View {
    var dish: Dish

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(dish.name)
                .font(.largeTitle)
                .bold()

            Group {
                Text("Calories: \(dish.calories)")

                if let fat = dish.fat {
                    Text("Fat: \(String(format: "%.1f", fat)) g")
                }
                if let saturatedFat = dish.saturatedFat {
                    Text("Saturated Fat: \(String(format: "%.1f", saturatedFat)) g")
                }
                if let cholesterol = dish.cholesterol {
                    Text("Cholesterol: \(String(format: "%.1f", cholesterol)) mg")
                }
                if let sodium = dish.sodium {
                    Text("Sodium: \(String(format: "%.1f", sodium)) mg")
                }
                if let carbs = dish.carbs {
                    Text("Carbohydrates: \(String(format: "%.1f", carbs)) g")
                }
                if let fiber = dish.fiber {
                    Text("Fiber: \(String(format: "%.1f", fiber)) g")
                }
                if let sugar = dish.sugar {
                    Text("Sugar: \(String(format: "%.1f", sugar)) g")
                }
                if let protein = dish.protein {
                    Text("Protein: \(String(format: "%.1f", protein)) g")
                }
            }
            .font(.title3)

            if let servingSize = dish.servingSize {
                Text("Serving Size: \(servingSize)")
                    .font(.headline)
                    .padding(.top)
            }
            if let vitamins = dish.vitamins, !vitamins.isEmpty {
                VStack(alignment: .leading) {
                    Text("Vitamins:")
                        .font(.headline)
                    ForEach(vitamins.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                        Text("\(key): \(String(format: "%.1f", value))% DV")
                    }
                }
                .padding(.top)
            }
            if let minerals = dish.minerals, !minerals.isEmpty {
                VStack(alignment: .leading) {
                    Text("Minerals:")
                        .font(.headline)
                    ForEach(minerals.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                        Text("\(key): \(String(format: "%.1f", value))% DV")
                    }
                }
                .padding(.top)
            }
            if let user = dish.user {
                Text("Added by: \(user.name)")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.top, 20)
            }
        }
    }
}

#Preview {
    let sampleDish = Dish(
        id: UUID(),
        name: "Grilled Chicken Salad",
        calories: 350,
        fat: 10.0,
        saturatedFat: 2.5,
        cholesterol: 55.0,
        sodium: 480.0,
        carbs: 20.0,
        fiber: 4.0,
        sugar: 5.0,
        protein: 30.0,
        vitamins: ["Vitamin A": 20.0, "Vitamin C": 15.0], minerals: ["Calcium": 8.0, "Iron": 10.0], servingSize: "1 bowl", mealEntries: [],
    )
    DishDetailView(dish: sampleDish)
}
