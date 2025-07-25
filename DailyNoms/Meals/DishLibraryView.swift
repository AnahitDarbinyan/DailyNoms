//
//  DishLibraryView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 15.06.25.
//

import PhotosUI
import SwiftData
import SwiftUI

enum DishLibraryFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case addedByMe = "Added by Me"
    case saved = "Saved"

    var id: String { rawValue }
}

struct DishLibraryView: View {
    @Query var allDishes: [Dish]
    @Environment(\.modelContext) var modelContext
    @State private var searchText = ""
    @State private var filter: DishLibraryFilter = .all
    @State private var showingAddDish = false

    var filteredDishes: [Dish] {
        allDishes
            .filter {
                switch filter {
                case .all:
                    return true
                case .addedByMe:
                    return $0.createdByUser
                case .saved:
                    return $0.saved
                }
            }
            .filter {
                searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)
            }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search dishes...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.horizontal, .top])

                Picker("Filter", selection: $filter) {
                    ForEach(DishLibraryFilter.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                List(filteredDishes) { dish in
                    NavigationLink(destination: DishEditView(dish: dish)) {
                        DishRow(dish: dish)
                    }
                }
            }
            .navigationTitle("Dish Library")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddDish = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddDish) {
                AddDishView() // Replace with your actual AddDishView
                    .presentationDetents([.medium, .large])
            }
        }
    }
}

struct DishRow: View {
    var dish: Dish

    var body: some View {
        HStack {
            if let imageData = dish.image, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
                    .overlay(Image(systemName: "photo").foregroundColor(.gray))
            }

            VStack(alignment: .leading) {
                Text(dish.name)
                HStack {
                    Text("\(dish.calories) kcal")
                    Text("/")
                    Text(dish.servingType == .plate ?
                        "100g" :
                        "1 \(dish.servingType.rawValue)")
                }
                .font(.caption)
                .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    DishLibraryView()
}
