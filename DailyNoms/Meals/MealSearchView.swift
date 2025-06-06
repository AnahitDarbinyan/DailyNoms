//
//  MealSearchView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 06.06.25.
//

import SwiftData
import SwiftUI

enum SearchKind: CaseIterable {
    case recents
    case favorites
}

struct MealSearchView: View {
    @Query var dishes: [Dish]
    @Environment(\.modelContext) var modelContext: ModelContext

    @State var selectedMealType: Meal.Kind
    @State var showMealOptions = false
    @State var selectedDishes = [Dish]()
    @State var searchText: String = ""
    @State var searchKind = SearchKind.recents

    var recents: [Dish] {
        let recents = dishes
            .filter{$0.mealEntries.count > 0}
            .sorted(by: { $0.mealEntries.count > $1.mealEntries.count })
        if recents.count < 10 {
            return recents
        } else {
            return Array(recents[0 ..< 10])
        }
    }

    var favorites: [Dish] {
        dishes.filter { $0.favorite }
    }

    var filtered: [Dish] {
        dishes.filter { $0.name.lowercased().contains(searchText.lowercased())
        }
    }
    
    init(mealType: Meal.Kind = .breakfast) {
        self.selectedMealType = mealType
    }
    
    func toggleDish(_ dish: Dish) {
            if selectedDishes.contains(dish) {
                let index = selectedDishes.firstIndex(of: dish)!
                selectedDishes.remove(at: index)
            } else {
                selectedDishes.append(dish)
            }
    }

    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            VStack(alignment: .center, spacing: 5) {
                Text(selectedMealType.rawValue)
                    .font(.title2)
                    .bold()
                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(showMealOptions ? 180 : 0))
                    .onTapGesture {
                        withAnimation {
                            showMealOptions.toggle()
                        }
                    }
            }

            if showMealOptions {
                ForEach(Meal.Kind.allCases, id: \.self) { type in
                    Text(type.rawValue)
                        .padding(.horizontal)
                        .onTapGesture {
                            selectedMealType = type
                            showMealOptions = false
                        }
                }
            }
            TextField("Search meals...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.horizontal, .top])

            Picker("", selection: $searchKind) {
                Text("Recents")
                    .tag(SearchKind.recents)
                Text("Favorites")
                    .tag(SearchKind.favorites)
            }
            .pickerStyle(.segmented)
            .labelsHidden()

            let options = searchText.count > 0 ? filtered : searchKind == .recents ? recents : favorites
            List {
                ForEach(options) { dish in
                    HStack {
                        VStack {
                            Text(dish.name)
                            Text("\(dish.calories)")
                            
                        }
                        Spacer()
                        Image(systemName: selectedDishes.contains(dish) ? "checkmark" : "plus")

                    }
                    .onTapGesture {
                        toggleDish(dish)
                    }
                }
            }
        }
        .overlay(
            Group {
                if selectedDishes.count > 0 {
                    VStack {
                        Divider()
                        HStack {
                            Button("+ Add") {}
                            let calories = selectedDishes.reduce(0) { $0 + $1.calories }
                            Text("\(calories) kcals")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(radius: 5)
                    }
                    .transition(.move(edge: .bottom))
                    .padding()
                }
            }
        )
    }
}

#Preview {
    MealSearchView()
}
