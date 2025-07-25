//
//  MealDetailView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 30.05.25.
//
//
import SwiftUI
import SwiftData

struct MealDetailView: View {
    @Bindable var meal: Meal

    var body: some View {
        List {
            Section {
                HStack {
                    Text("Total Calories")
                        .font(.headline)
                    Spacer()
                    Text("\(meal.dishServings.isEmpty ? 0 : meal.calories) kcal")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }

            ForEach(meal.dishServings, id: \.id) { serving in
                    let dish = serving.dish
                    NavigationLink(destination: DishDetailView(dish: dish)) {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(dish.name)
                                    .font(.headline)
                                Spacer()
                                Text("\(serving.calories) kcal")
                                    .foregroundColor(.secondary)
                            }

                            HStack(spacing: 4) {
                                Text(String(format: "%.1f ×", serving.servings))
                                Text(String(format: "%.0f g", dish.servingSize))
                                Text("(\(dish.servingType.rawValue))")
                                Spacer()
                            }
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        }
                        .padding(.vertical, 4)
                    }
                
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Unknown Dish")
                            .font(.headline)
                            .foregroundColor(.red)
                        Text("Dish data unavailable")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                
            }
        }
        .navigationTitle(meal.mealtype.rawValue.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            print("MealDetailView for \(meal.mealtype.rawValue):")
            let servingDescriptions = meal.dishServings.map { serving in
                "Dish: \(serving.dish.name ?? "nil"), Calories: \(serving.calories), Servings: \(serving.servings)"
            }
            print("dishServings = \(servingDescriptions)")
        }
    }
}

struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let (meal, container) = previewMealAndContainer()
        MealDetailView(meal: meal)
            .modelContainer(container)
    }

    static func previewMealAndContainer() -> (Meal, ModelContainer) {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Meal.self, DishServing.self, Dish.self, User.self, configurations: config)
        let context = container.mainContext

        let dish = Dish(
            name: "Pancakes",
            calories: 200,
            fat: 10,
            carbs: 30,
            protein: 5,
            servingSize: 100,
            servingType: .plate
        )
        let serving = DishServing(dish: dish, servings: 2)
        let meal = Meal(mealtype: .breakfast, dishServings: [serving], user: nil)
        meal.date = Date()

        context.insert(dish)
        context.insert(serving)
        context.insert(meal)
        try! context.save()

        return (meal, container)
    }
}



//import SwiftUI
//
//struct MealDetailView: View {
//    let meal: Meal
//
//    var body: some View {
//        List {
//            Section {
//                HStack {
//                    Text("Total Calories")
//                        .font(.headline)
//                    Spacer()
//                    Text("\(meal.calories) kcal")
//                        .font(.headline)
//                        .foregroundColor(.blue)
//                }
//            }
//
//            ForEach(meal.dishServings) { serving in
//                NavigationLink(destination: DishDetailView(dish: serving.dish ?? "Unnamed Dish")) {
//                    VStack(alignment: .leading, spacing: 4) {
//                        HStack {
//                            Text(serving.dish.name ?? "Unnamed Dish")
//                                .font(.headline)
//                            Spacer()
//                            Text("\(serving.calories) kcal")
//                                .foregroundColor(.secondary)
//                        }
//
//                        HStack(spacing: 4) {
//                            Text(String(format: "%.1f ×", serving.servings))
//                            Text(String(format: "%.0f g", serving.dish.servingSize))
//                            Text("(\(serving.dish.servingType.rawValue))")
//                            Spacer()
//                        }
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                    }
//                    .padding(.vertical, 4)
//                }
//            }
//        }
//        .navigationTitle(meal.mealtype.rawValue.capitalized)
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}
//
//#Preview {
//    let sampleMeal = Meal(
//        mealtype: .breakfast,
//        dishServings: [], user: nil
//    )
//    return MealDetailView(meal: sampleMeal)
//}
