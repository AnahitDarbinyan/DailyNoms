//
//  MealSearchView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 06.06.25.
//

//import SwiftData
//import SwiftUI
//
//struct SelectedDishWithWeight: Identifiable, Equatable {
//    var id: UUID { dish.id }
//    var dish: Dish
//    var servingSize: Double
//    var servings: Int
//
//    var calories: Int {
//        let ratio = Double(servings) * servingSize / 100
//        return Int(Double(dish.calories) * ratio)
//    }
//}
//
//enum SearchKind: CaseIterable {
//    case recents
//    case favorites
//}
//
//struct MealSearchView: View {
//    @Query var dishes: [Dish]
//    @Environment(\.modelContext) var modelContext: ModelContext
//    @Environment(\.dismiss) var dismiss
//
//    @State var selectedMealType: Meal.Kind
//    @State var showMealOptions = false
//    @State var searchText: String = ""
//    @State var searchKind: SearchKind? = nil
//    @State private var selectedDishes: [SelectedDishWithWeight] = []
//
//    var recents: [Dish] {
//        let recents = dishes
//            .filter { $0.dishServings.count > 0 }
//            .sorted { $0.dishServings.count > $1.dishServings.count }
//        return Array(recents.prefix(10))
//    }
//
//    var favorites: [Dish] {
//        dishes.filter { $0.favorite }
//    }
//
//    var filtered: [Dish] {
//        dishes.filter { $0.name.lowercased().contains(searchText.lowercased()) }
//    }
//
//    var options: [Dish] {
//        if searchText.count > 0 {
//            return filtered
//        } else {
//            if let kind = searchKind {
//                return kind == .recents ? recents : favorites
//            }
//            return dishes.sorted { $0.name.lowercased() < $1.name.lowercased() }
//        }
//    }
//
//    var groupedDishes: [(letter: String, dishes: [Dish])] {
//        let sortedDishes = dishes.sorted { $0.name.lowercased() < $1.name.lowercased() }
//        let grouped = Dictionary(grouping: sortedDishes) { dish in
//            String(dish.name.lowercased().prefix(1))
//        }
//        return grouped.map { (letter: $0.key, dishes: $0.value) }
//            .sorted { $0.letter < $1.letter }
//    }
//
//    init(mealType: Meal.Kind = .breakfast) {
//        _selectedMealType = State(initialValue: mealType)
//        _searchKind = State(initialValue: nil)
//    }
//
//    func toggleDish(_ dish: Dish) {
//        if let index = selectedDishes.firstIndex(where: { $0.dish.id == dish.id }) {
//            selectedDishes.remove(at: index)
//        } else {
//            selectedDishes.append(
//                SelectedDishWithWeight(
//                    dish: dish,
//                    servingSize: dish.servingSize,
//                    servings: 1
//                )
//            )
//        }
//    }
//
//    var body: some View {
//        VStack(spacing: 12) {
//            mealTypeHeader
//            if showMealOptions {
//                mealOptionsView
//            }
//            searchField
//            pickerView
//            dishesList
//        }
//        .padding(.vertical)
//        .background(
//            RoundedRectangle(cornerRadius: 20)
//                .fill(Color(.systemBackground).opacity(0.9))
//                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 20)
//                        .stroke(Color(.systemGray4), lineWidth: 1)
//                )
//        )
//        .clipShape(RoundedRectangle(cornerRadius: 20))
//        .sheet(isPresented: .constant(!selectedDishes.isEmpty)) {
//            overlay
//                .presentationDetents([.height(120), .medium, .large])
//                .presentationBackgroundInteraction(.enabled(upThrough: .height(120)))
//                .presentationBackground(.ultraThinMaterial)
//        }
//    }
//
//    var mealTypeHeader: some View {
//        VStack(alignment: .center, spacing: 5) {
//            Text(selectedMealType.rawValue)
//                .font(.system(.title2, design: .rounded))
//                .fontWeight(.bold)
//                .foregroundColor(Color("Calories"))
//            Image(systemName: "chevron.down")
//                .foregroundColor(Color("Calories"))
//                .rotationEffect(.degrees(showMealOptions ? 180 : 0))
//                .onTapGesture {
//                    withAnimation(.easeInOut) {
//                        showMealOptions.toggle()
//                    }
//                }
//        }
//        .padding(.vertical, 8)
//    }
//
//    var mealOptionsView: some View {
//        VStack(spacing: 8) {
//            ForEach(Meal.Kind.allCases, id: \.self) { type in
//                Text(type.rawValue)
//                    .font(.system(.body, design: .rounded))
//                    .foregroundColor(Color("Calories"))
//                    .padding(.vertical, 4)
//                    .padding(.horizontal)
//                    .frame(maxWidth: .infinity)
//                    .background(Color(.systemGray6))
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                    .onTapGesture {
//                        withAnimation(.easeInOut) {
//                            selectedMealType = type
//                            showMealOptions = false
//                        }
//                    }
//            }
//        }
//        .padding(.horizontal)
//    }
//
//    var searchField: some View {
//        TextField("Search dishes...", text: $searchText)
//            .textFieldStyle(.roundedBorder)
//            .padding([.horizontal, .top])
//            .background(
//                RoundedRectangle(cornerRadius: 10)
//                    .fill(Color(.systemBackground))
//                    .shadow(color: .black.opacity(0.1), radius: 4)
//            )
//    }
//
//    var pickerView: some View {
//        Picker("", selection: $searchKind) {
//            Text("All").tag(SearchKind?.none)
//            Text("Recents").tag(SearchKind.recents as SearchKind?)
//            Text("Favorites").tag(SearchKind.favorites as SearchKind?)
//        }
//        .pickerStyle(.segmented)
//        .labelsHidden()
//        .padding(.horizontal)
//    }
//
//    var dishesList: some View {
//        List {
//            if searchText.isEmpty && searchKind == nil {
//                if groupedDishes.isEmpty {
//                    Text("No dishes available")
//                        .font(.system(.body, design: .rounded))
//                        .foregroundColor(.gray)
//                } else {
//                    ForEach(groupedDishes, id: \.letter) { group in
//                        Section(header: Text(group.letter.uppercased())
//                            .font(.system(.title3, design: .rounded))
//                            .fontWeight(.bold)
//                            .foregroundColor(Color("Calories"))) {
//                            ForEach(group.dishes) { dish in
//                                dishRow(dish: dish)
//                            }
//                        }
//                    }
//                }
//            } else {
//                if options.isEmpty {
//                    Text("No dishes found")
//                        .font(.system(.body, design: .rounded))
//                        .foregroundColor(.gray)
//                } else {
//                    ForEach(options) { dish in
//                        dishRow(dish: dish)
//                    }
//                }
//            }
//        }
//        .scrollContentBackground(.hidden)
//    }
//
//    func dishRow(dish: Dish) -> some View {
//        HStack {
//            VStack(alignment: .leading) {
//                Text(dish.name)
//                    .font(.system(.body, design: .rounded))
//                    .foregroundColor(.primary)
//                Text("\(dish.calories) kcal / 100g")
//                    .font(.system(.caption, design: .rounded))
//                    .foregroundColor(.gray)
//            }
//            Spacer()
//            Image(systemName: selectedDishes.contains(where: { $0.dish.id == dish.id }) ? "checkmark.circle.fill" : "plus.circle.fill")
//                .foregroundColor(Color("Calories"))
//                .font(.system(size: 20))
//        }
//        .padding(.vertical, 4)
//        .contentShape(Rectangle())
//        .onTapGesture {
//            withAnimation(.easeInOut) {
//                toggleDish(dish)
//            }
//        }
//    }
//
//    var overlay: some View {
//        VStack(spacing: 0) {
//
//            Text("Selected Dishes")
//                .font(.system(.headline, design: .rounded))
//                .foregroundColor(Color("Calories"))
//                .padding(.top, 4)
//
//            Divider()
//
//            selectedDishesView
//        }
//    }
//
//    var selectedDishesView: some View {
//        VStack(spacing: 0) {
//            ScrollView {
//                VStack(spacing: 8) {
//                    ForEach($selectedDishes) { $item in
//                        dishServingRow(item: $item)
//                    }
//                }
//                .padding()
//            }
//            .frame(maxHeight: 200)
//
//            Divider()
//
//            HStack {
//                let totalCalories = selectedDishes.reduce(0) { $0 + $1.calories }
//                Text("\(totalCalories) kcal total")
//                    .font(.system(.subheadline, design: .rounded))
//                    .foregroundColor(.gray)
//                Spacer()
//                Button("+ Add (\(selectedDishes.count))") {
//                    let dishServings = selectedDishes.map { item in
//                        DishServing(
//                            dish: item.dish,
//                            servings: Double(item.servings),
//                            servingSize: item.servingSize,
//                            meal: nil
//                        )
//                    }
//                    let newMeal = Meal(mealtype: selectedMealType, dishServings: dishServings, user: nil)
//                    modelContext.insert(newMeal)
//                    try? modelContext.save()
//                    dismiss()
//                }
//                .foregroundColor(.white)
//                .padding(.horizontal, 16)
//                .padding(.vertical, 8)
//                .background(Color("Calories"))
//                .clipShape(RoundedRectangle(cornerRadius: 16))
//            }
//            .padding()
//        }
//    }
//
//    func dishServingRow(item: Binding<SelectedDishWithWeight>) -> some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 4) {
//                Text(item.wrappedValue.dish.name)
//                    .font(.system(.headline, design: .rounded))
//                    .foregroundColor(.primary)
//                Text("\(item.wrappedValue.calories) kcal")
//                    .font(.system(.subheadline, design: .rounded))
//                    .foregroundColor(.gray)
//
//                HStack(spacing: 8) {
//                    Text(String(describing: item.wrappedValue.dish.servingType))
//                        .font(.system(.caption, design: .rounded))
//                        .foregroundColor(.gray)
//                    Button {
//                        if item.wrappedValue.servings > 1 {
//                            item.wrappedValue.servings -= 1
//                        }
//                    } label: {
//                        Image(systemName: "minus.circle.fill")
//                            .foregroundColor(Color("Calories"))
//                    }
//                    TextField("", value: item.servings, format: .number)
//                        .keyboardType(.decimalPad)
//                        .frame(width: 50)
//                        .multilineTextAlignment(.center)
//                        .textFieldStyle(.roundedBorder)
//                        .background(Color(.systemGray6))
//                        .clipShape(RoundedRectangle(cornerRadius: 8))
//                    Button {
//                        item.wrappedValue.servings += 1
//                    } label: {
//                        Image(systemName: "plus.circle.fill")
//                            .foregroundColor(Color("Calories"))
//                    }
//                }
//
//                HStack(spacing: 8) {
//                    Text("Grams:")
//                        .font(.system(.caption, design: .rounded))
//                        .foregroundColor(.gray)
//                    Button {
//                        if item.wrappedValue.servingSize > 1 {
//                            item.wrappedValue.servingSize -= 1
//                        }
//                    } label: {
//                        Image(systemName: "minus.circle.fill")
//                            .foregroundColor(Color("Calories"))
//                    }
//                    TextField("", value: item.servingSize, format: .number)
//                        .keyboardType(.decimalPad)
//                        .frame(width: 50)
//                        .multilineTextAlignment(.center)
//                        .textFieldStyle(.roundedBorder)
//                        .background(Color(.systemGray6))
//                        .clipShape(RoundedRectangle(cornerRadius: 8))
//                    Button {
//                        item.wrappedValue.servingSize += 1
//                    } label: {
//                        Image(systemName: "plus.circle.fill")
//                            .foregroundColor(Color("Calories"))
//                    }
//                }
//            }
//            Spacer()
//            Button(action: {
//                toggleDish(item.wrappedValue.dish)
//            }) {
//                Image(systemName: "xmark.circle.fill")
//                    .foregroundColor(.red)
//            }
//        }
//        .padding(.vertical, 8)
//        .padding(.horizontal, 12)
//        .background(Color(.systemGray6))
//        .clipShape(RoundedRectangle(cornerRadius: 10))
//    }
//}
//
//#Preview {
//    MealSearchView()
//}

import SwiftData
import SwiftUI

struct SelectedDishWithWeight: Identifiable, Equatable {
    var id: UUID { dish.id }
    var dish: Dish
    var servingSize: Double
    var servings: Int

    var calories: Int {
        let ratio = Double(servings) * servingSize / 100
        return Int(Double(dish.calories) * ratio)
    }
}

enum SearchKind: CaseIterable {
    case recents
    case favorites
}

struct MealSearchView: View {
    @Query var dishes: [Dish]
    @Environment(\.modelContext) var modelContext: ModelContext
    @Environment(\.dismiss) var dismiss

    @State var selectedMealType: Meal.Kind
    @State var showMealOptions = false
    @State var searchText: String = ""
    @State var searchKind: SearchKind? = nil
    @State private var selectedDishes: [SelectedDishWithWeight] = []
    @State private var isSheetPresented = false

    var recents: [Dish] {
        let recents = dishes
            .filter { $0.dishServings.count > 0 }
            .sorted { $0.dishServings.count > $1.dishServings.count }
        return Array(Set(recents).prefix(10)) // Deduplicate recents
    }

    var favorites: [Dish] {
        Array(Set(dishes.filter { $0.favorite })) // Deduplicate favorites
    }

    var filtered: [Dish] {
        Array(Set(dishes.filter { $0.name.lowercased().contains(searchText.lowercased()) })) // Deduplicate filtered
    }

    var options: [Dish] {
        if searchText.count > 0 {
            return filtered
        } else {
            if let kind = searchKind {
                return kind == .recents ? recents : favorites
            }
            return Array(Set(dishes)).sorted { $0.name.lowercased() < $1.name.lowercased() } // Deduplicate all dishes
        }
    }

    var groupedDishes: [(letter: String, dishes: [Dish])] {
        let sortedDishes = options // Use deduplicated options
        let grouped = Dictionary(grouping: sortedDishes) { dish in
            String(dish.name.lowercased().prefix(1))
        }
        return grouped.map { (letter: $0.key, dishes: Array(Set($0.value))) } // Deduplicate within groups
            .sorted { $0.letter < $1.letter }
    }

    init(mealType: Meal.Kind = .breakfast) {
        _selectedMealType = State(initialValue: mealType)
        _searchKind = State(initialValue: nil)
    }

    func toggleDish(_ dish: Dish) {
        if let index = selectedDishes.firstIndex(where: { $0.dish.id == dish.id }) {
            selectedDishes.remove(at: index)
        } else {
            selectedDishes.append(
                SelectedDishWithWeight(
                    dish: dish,
                    servingSize: dish.servingSize,
                    servings: 1
                )
            )
        }
        isSheetPresented = !selectedDishes.isEmpty
    }

    var body: some View {
        VStack(spacing: 12) {
            mealTypeHeader
            if showMealOptions {
                mealOptionsView
            }
            searchField
            pickerView
            dishesList
        }
        .padding(.vertical)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground).opacity(0.95))
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .sheet(isPresented: $isSheetPresented) {
            overlay
                .presentationDetents([.fraction(0.3), .medium, .large])
                .presentationDragIndicator(.visible)
                .presentationBackground(.ultraThinMaterial)
                .presentationCornerRadius(20)
        }
        .onChange(of: selectedDishes) { _, _ in
            isSheetPresented = !selectedDishes.isEmpty
        }
    }

    var mealTypeHeader: some View {
        VStack(alignment: .center, spacing: 5) {
            Text(selectedMealType.rawValue.capitalized)
                .font(.system(.title2, design: .rounded, weight: .bold))
                .foregroundStyle(Color("MidnightPurple"))
            Image(systemName: "chevron.down")
                .foregroundStyle(Color("MidnightPurple"))
                .rotationEffect(.degrees(showMealOptions ? 180 : 0))
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        showMealOptions.toggle()
                    }
                }
        }
        .padding(.vertical, 8)
    }

    var mealOptionsView: some View {
        VStack(spacing: 8) {
            ForEach(Meal.Kind.allCases, id: \.self) { type in
                Text(type.rawValue.capitalized)
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(Color("MidnightPurple"))
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            selectedMealType = type
                            showMealOptions = false
                        }
                    }
            }
        }
        .padding(.horizontal)
    }

    var searchField: some View {
        TextField("Search dishes...", text: $searchText)
            .textFieldStyle(.roundedBorder)
            .padding([.horizontal, .top])
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 4)
            )
    }

    var pickerView: some View {
        Picker("", selection: $searchKind) {
            Text("All").tag(SearchKind?.none)
            Text("Recents").tag(SearchKind.recents as SearchKind?)
            Text("Favorites").tag(SearchKind.favorites as SearchKind?)
        }
        .pickerStyle(.segmented)
        .labelsHidden()
        .padding(.horizontal)
    }

    var dishesList: some View {
        List {
            if searchText.isEmpty && searchKind == nil {
                if groupedDishes.isEmpty {
                    Text("No dishes available")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.gray)
                } else {
                    ForEach(groupedDishes, id: \.letter) { group in
                        Section(header: Text(group.letter.uppercased())
                            .font(.system(.title3, design: .rounded, weight: .bold))
                            .foregroundStyle(Color("MidnightPurple"))) {
                            ForEach(group.dishes) { dish in
                                dishRow(dish: dish)
                            }
                        }
                    }
                }
            } else {
                if options.isEmpty {
                    Text("No dishes found")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.gray)
                } else {
                    ForEach(options) { dish in
                        dishRow(dish: dish)
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
    }

    func dishRow(dish: Dish) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(dish.name)
                    .font(.system(.body, design: .rounded, weight: .medium))
                    .foregroundStyle(.primary)
                Text("\(dish.calories) kcal / 100g")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.gray)
            }
            Spacer()
            Image(systemName: selectedDishes.contains(where: { $0.dish.id == dish.id }) ? "checkmark.circle.fill" : "plus.circle.fill")
                .foregroundStyle(Color("MidnightPurple"))
                .font(.system(size: 22, weight: .medium))
                .scaleEffect(selectedDishes.contains(where: { $0.dish.id == dish.id }) ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: selectedDishes)
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut) {
                toggleDish(dish)
            }
        }
    }

    var overlay: some View {
        VStack(spacing: 12) {
            Text("Selected Dishes")
                .font(.system(.title3, design: .rounded, weight: .bold))
                .foregroundStyle(Color(.systemGray5))
                .padding(.top, 12)
                .padding(.bottom, 8)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach($selectedDishes) { $item in
                        dishServingRow(item: $item)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color("MidnightPurple"), lineWidth: 1)
            )

            HStack {
                let totalCalories = selectedDishes.reduce(0) { $0 + $1.calories }
                Text("\(totalCalories) kcal total")
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .foregroundStyle(Color(.systemGray5))
                    .padding(.leading, 16)
                Spacer()
                Button(action: {
                    let dishServings = selectedDishes.map { item in
                        DishServing(
                            dish: item.dish,
                            servings: Double(item.servings),
                            servingSize: item.servingSize,
                            meal: nil
                        )
                    }
                    let newMeal = Meal(mealtype: selectedMealType, dishServings: dishServings, user: nil)
                    modelContext.insert(newMeal)
                    dishServings.forEach { modelContext.insert($0) }
                    do {
                        try modelContext.save()
                        print("Saved meal: \(newMeal.mealtype.rawValue), dishes: \(dishServings.map { $0.dish.name ?? "nil" })")
                    } catch {
                        print("Error saving meal: \(error)")
                    }
                    selectedDishes = []
                    isSheetPresented = false
                    dismiss()
                }) {
                    Text("+ Add (\(selectedDishes.count))")
                        .font(.system(.body, design: .rounded, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color("MidnightPurple"))
                        .clipShape(Capsule())
                        .shadow(color: Color("MidnightPurple").opacity(0.5), radius: 4, x: 0, y: 2)
                }
                .buttonStyle(.plain)
                .scaleEffect(isSheetPresented ? 1.0 : 0.95)
                .animation(.easeInOut(duration: 0.2), value: isSheetPresented)
                .padding(.trailing, 16)
            }
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color("MidnightPurple"), lineWidth: 1)
            )
        }
        .padding(.vertical)
        .background(.ultraThinMaterial)
    }

    func dishServingRow(item: Binding<SelectedDishWithWeight>) -> some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(item.wrappedValue.dish.name)
                    .font(.system(.headline, design: .rounded, weight: .medium))
                    .foregroundStyle(Color(.systemGray5))
                Text("\(item.wrappedValue.calories) kcal")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(Color(.systemGray5).opacity(0.9))

                HStack(spacing: 8) {
                    Text(item.wrappedValue.dish.servingType.rawValue.capitalized)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(Color(.systemGray5).opacity(0.9))
                    Button {
                        if item.wrappedValue.servings > 1 {
                            item.wrappedValue.servings -= 1
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundStyle(Color("MidnightPurple"))
                            .font(.system(size: 18))
                    }
                    .buttonStyle(.plain)
                    .scaleEffect(item.wrappedValue.servings > 1 ? 1.0 : 0.95)
                    .animation(.easeInOut(duration: 0.2), value: item.wrappedValue.servings)
                    TextField("", value: item.servings, format: .number)
                        .keyboardType(.numberPad)
                        .frame(width: 50)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.roundedBorder)
                        .foregroundStyle(Color(.systemGray5))
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("MidnightPurple"), lineWidth: 1)
                        )
                    Button {
                        item.wrappedValue.servings += 1
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(Color("MidnightPurple"))
                            .font(.system(size: 18))
                    }
                    .buttonStyle(.plain)
                    .scaleEffect(1.0)
                    .animation(.easeInOut(duration: 0.2), value: item.wrappedValue.servings)
                }

                HStack(spacing: 8) {
                    Text("Grams:")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(Color(.systemGray5).opacity(0.9))
                    Button {
                        if item.wrappedValue.servingSize > 1 {
                            item.wrappedValue.servingSize -= 1
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundStyle(Color("MidnightPurple"))
                            .font(.system(size: 18))
                    }
                    .buttonStyle(.plain)
                    .scaleEffect(item.wrappedValue.servingSize > 1 ? 1.0 : 0.95)
                    .animation(.easeInOut(duration: 0.2), value: item.wrappedValue.servingSize)
                    TextField("", value: item.servingSize, format: .number)
                        .keyboardType(.decimalPad)
                        .frame(width: 50)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.roundedBorder)
                        .foregroundStyle(Color(.systemGray5))
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("MidnightPurple"), lineWidth: 1)
                        )
                    Button {
                        item.wrappedValue.servingSize += 1
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(Color("MidnightPurple"))
                            .font(.system(size: 18))
                    }
                    .buttonStyle(.plain)
                    .scaleEffect(1.0)
                    .animation(.easeInOut(duration: 0.2), value: item.wrappedValue.servingSize)
                }
            }
            Spacer()
            Button {
                toggleDish(item.wrappedValue.dish)
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.red)
                    .font(.system(size: 18))
            }
            .buttonStyle(.plain)
            .scaleEffect(1.0)
            .animation(.easeInOut(duration: 0.2), value: selectedDishes)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .background(Color("MidnightPurple").opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color("MidnightPurple").opacity(0.5), radius: 6, x: 0, y: 3)
        .scaleEffect(selectedDishes.contains(where: { $0.id == item.wrappedValue.id }) ? 1.02 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: selectedDishes)
    }
}

#Preview {
    struct Preview: View {
        var body: some View {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try! ModelContainer(for: Dish.self, DishServing.self, Meal.self, User.self, configurations: config)
            let context = container.mainContext
            // Check for existing dishes to avoid duplicates
            let existingDishes = try! context.fetch(FetchDescriptor<Dish>(predicate: #Predicate { $0.name == "Pancakes" }))
            if existingDishes.isEmpty {
                let dish = Dish(
                    name: "Pancakes",
                    calories: 200,
                    fat: 10,
                    saturatedFat: nil,
                    cholesterol: nil,
                    sodium: nil,
                    carbs: 30,
                    fiber: nil,
                    sugar: nil,
                    protein: 5,
                    vitamins: ["Vitamin A": 10],
                    minerals: ["Iron": 2],
                    servingSize: 100,
                    servingType: .plate
                )
                context.insert(dish)
                try! context.save()
            }
            return MealSearchView(mealType: .breakfast)
                .modelContainer(container)
        }
    }
    return Preview()
}
