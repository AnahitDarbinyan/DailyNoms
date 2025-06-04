//
//  AddDishView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 30.05.25.
//

import SwiftUI
import SwiftData

extension Binding<Dish?>: Equatable{
    public static func == (lhs: Binding<Dish?>, rhs: Binding<Dish?>) -> Bool {
        lhs.wrappedValue === rhs.wrappedValue
    }
}
struct AddMealView: View {
    let user: User
    @State private var newDishName = ""
    @State var dish: Dish?
    @State private var calories = 0
    @State private var mealType = Meal.Kind.breakfast
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext: ModelContext
    @Query var dishes: [Dish]
    var top5Dishes: [Dish] {
        let favourites = dishes.sorted(by: {$0.mealEntries.count > $1.mealEntries.count})
    if favourites.count < 5 {
        return favourites
    } else {
        return Array(favourites [0..<5])
    }
                        
    }
    
    
    var body: some View {
        Form {
            Section(header: Text("Add a meal")) {
                Picker("Your favourites", selection: $dish) {
                    ForEach(top5Dishes){ dish in
                        Text(dish.name).tag(dish)
                    }
        
                }
                .pickerStyle(.inline)
                .onChange(of: $dish) {
                    newDishName = dish?.name ?? newDishName
                }
                
                TextField("Dish", text: $newDishName)
//                    .onChange(of: $newDishName){
//                        dish = nil
//                    }
                TextField("Calories", value: $calories, format: .number)
                    .keyboardType(.numberPad)
                
                Picker("Meal type", selection: $mealType) {
                    ForEach(Meal.Kind.allCases, id: \.self){ kind in
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
        var newDish: Dish!
        if let dish = dish {
            newDish = dish
        } else{
            newDish = Dish(id: UUID(), name: newDishName, calories: calories, mealEntries: [])
            modelContext.insert(newDish)
        }
        let entry = Meal(mealtype: mealType, dishes: [newDish], user: user)
        
        modelContext.insert(entry)
        
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
