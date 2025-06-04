//
//  ContentView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 22.05.25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Environment(\.modelContext) var modelContext: ModelContext
    @Query(filter: Meal.sinceMorning(), sort: \.date) var meals: [Meal]
    @Query var users: [User]
    
    var user: User {
        if let first = users.first {
            return first
        } else {
            let newUser = User(name: "Preview", age: 25, gender: .female)
            modelContext.insert(newUser)
            try? modelContext.save() // Save the new user
            return newUser
        }
    }

    
    var snapshot: Snapshot {
        if let first = user.snapshots.first {
            return first
        } else {
            let newSnapshot = Snapshot(weight: 60, height: 165, user: user)
            user.snapshots.append(newSnapshot)
            try? modelContext.save() // Save it
            return newSnapshot
        }
    }

    
    var expectedCalories: Int {
        let weight = Double(snapshot.weight)
        let height = Double(snapshot.height)
        let age = Double(user.age)
        let gender = user.gender
        var bmr: Double
        
        if gender.rawValue == "male" {
            bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5
        } else {
            bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161
        }
        
        return Int(bmr)
    }
    
    var caloriesEaten: Int {
        meals.reduce(0) { $0 + $1.calories }
    }
    
    var caloriesRemaining: Int {
        expectedCalories - caloriesEaten
    }
    
    var totalProtein: Double {
        meals.reduce(0) { total, meal in
            total + meal.dishes.reduce(0) { $0 + ($1.protein ?? 0) }
        }
    }
    
    var totalFat: Double {
        meals.reduce(0) { total, meal in
            total + meal.dishes.reduce(0) { $0 + ($1.fat ?? 0) }
        }
    }
    
    var totalCarbs: Double {
        meals.reduce(0) { total, meal in
            total + meal.dishes.reduce(0) { $0 + ($1.carbs ?? 0) }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 30) {
                    CalorieProgressView(remaining: caloriesRemaining, current: caloriesEaten)
                    
                    HStack(spacing: 0) {
                        ComponentView(title: "Protein", current: Int(totalProtein), total: 10, color: .orange)
                            .frame(minWidth: 50, maxWidth: .infinity)
                        ComponentView(title: "Carbs", current: Int(totalCarbs), total: 10, color: .teal)
                            .frame(minWidth: 50, maxWidth: .infinity)
                        ComponentView(title: "Fat", current: Int(totalFat), total: 10, color: .red)
                            .frame(minWidth: 50, maxWidth: .infinity)
                    }
                    .padding(.horizontal, 20)
                    
                    MealCategoryView()
                    
                    ForEach(meals) { meal in
                        VStack(alignment: .leading) {
                            Text(meal.mealtype.rawValue.capitalized)
                                .font(.headline)
                            Text("\(meal.calories) kcal")
                                .font(.subheadline)
                            
                            ForEach(meal.dishes) { dish in
                                NavigationLink(destination: DishDetailView(dish: dish)) {
                                    Text(dish.name)
                                        .padding(5)
                                        .background(Color(.systemGray5))
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .shadow(radius: 1)
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 50)
            }
            .navigationTitle("Daily Noms") 
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddMealView(user: user)) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}

