//
//  AddMealView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 30.05.25.
//

// import SwiftData
// import SwiftUI
//
// extension Binding<Dish?>: Equatable {
//    public static func == (lhs: Binding<Dish?>, rhs: Binding<Dish?>) -> Bool {
//        lhs.wrappedValue === rhs.wrappedValue
//    }
// }
//
// struct AddMealView: View {
//    let user: User
//    @State private var newDishName = ""
//    @State var dish: Dish?
//    @State private var calories = 0
//    @State private var mealType = Meal.Kind.breakfast
//    @Environment(\.dismiss) private var dismiss
//    @Environment(\.modelContext) private var modelContext: ModelContext
//    @Query var dishes: [Dish]
//    var top5Dishes: [Dish] {
//        let favourites = dishes.sorted(by: { $0.dishServings.count > $1.dishServings.count })
//        if favourites.count < 5 {
//            return favourites
//        } else {
//            return Array(favourites[0 ..< 5])
//        }
//    }
//
//    var body: some View {
//        Form {
//            Section(header: Text("Add a meal")) {
//                Picker("Your favourites", selection: $dish) {
//                    ForEach(top5Dishes) { dish in
//                        Text(dish.name).tag(dish)
//                    }
//                }
//                .pickerStyle(.inline)
//                .onChange(of: $dish) {
//                    newDishName = dish?.name ?? newDishName
//                }
//
//                TextField("Dish", text: $newDishName)
////                    .onChange(of: $newDishName){
////                        dish = nil
////                    }
//                TextField("Calories", value: $calories, format: .number)
//                    .keyboardType(.numberPad)
//
//                Picker("Meal type", selection: $mealType) {
//                    ForEach(Meal.Kind.allCases, id: \.self) { kind in
//                        Text(kind.rawValue.capitalized)
//                    }
//                }
//            }
//
//            Button("Save") {
//                saveMeal()
//                dismiss()
//            }
//        }
//        .navigationTitle("New Meal")
//    }
//
//    func saveMeal() {
//        var newDish: Dish!
//        if let dish = dish {
//            newDish = dish
//        } else {
//            newDish = Dish(name: newDishName,
//                           calories: calories,
////                           fat: fat,
////                           carbs: carbs,
////                           protein: protein,
//                           dishServings: [])
//            modelContext.insert(newDish)
//        }
//        let entry = Meal(mealtype: mealType, dishServings: [], user: user)
//
//        modelContext.insert(entry)
//
//        try? modelContext.save()
//    }
// }

import SwiftData
import SwiftUI

struct AddMealView: View {
    let user: User

    @State private var newDishName = ""
    @State private var dish: Dish?
    @State private var servings: Double = 1.0
    @State private var mealType = Meal.Kind.breakfast

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext: ModelContext
    @Query var dishes: [Dish]

    var top5Dishes: [Dish] {
        let favourites = dishes.sorted(by: { $0.dishServings.count > $1.dishServings.count })
        return Array(favourites.prefix(5))
    }

    var body: some View {
        Form {
            Section(header: Text("Add a meal")) {
                Picker("Your favourites", selection: $dish) {
                    ForEach(top5Dishes) { dish in
                        Text(dish.name).tag(dish as Dish?)
                    }
                }
                .pickerStyle(.inline)
                .onChange(of: dish) { newValue in
                    newDishName = newValue?.name ?? ""
                }

                TextField("Dish", text: $newDishName)
                    .onChange(of: newDishName) { _ in
                        dish = nil
                    }

                HStack {
                    Text("Servings")
                    Spacer()
                    Stepper(value: $servings, in: 0.5 ... 10, step: 0.5) {
                        Text("\(servings, specifier: "%.1f")")
                    }
                }

                Picker("Meal type", selection: $mealType) {
                    ForEach(Meal.Kind.allCases, id: \.self) { kind in
                        Text(kind.rawValue.capitalized)
                    }
                }
            }

            Button("Save") {
                saveMeal()
                dismiss()
            }
        }
        .navigationTitle("New Meal")
    }

    func saveMeal() {
        let finalDish: Dish

        if let selectedDish = dish {
            finalDish = selectedDish
        } else {
            finalDish = Dish(
                name: newDishName,
                calories: 0,
                fat: 0.0,
                carbs: 0.0,
                protein: 0.0
            )
            modelContext.insert(finalDish)
        }

        let newMeal = Meal(
            mealtype: mealType,
            dishServings: [],
            user: user
        )
        modelContext.insert(newMeal)

        let newServing = DishServing(
            dish: finalDish,
            servings: servings,
            meal: newMeal
        )
        modelContext.insert(newServing)

        newMeal.dishServings.append(newServing)
        finalDish.dishServings.append(newServing)

        try? modelContext.save()
    }
}

#Preview {
    let sampleUser = User(
        name: "Preview User",
        age: 30,
        gender: .male
    )

    AddMealView(user: sampleUser)
}
