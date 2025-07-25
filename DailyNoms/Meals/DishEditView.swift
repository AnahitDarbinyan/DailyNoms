//
//  DishEditView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 15.06.25.
//

import PhotosUI
import SwiftData
import SwiftUI

struct DishEditView: View {
    @Bindable var dish: Dish
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var isEditing = false
    @State private var imageSelection: PhotosPickerItem? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    image

                    TextField("Dish Name", text: $dish.name)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .disabled(!isEditing)

                    Divider()
                        .frame(height: 1)
                        .background(Color.gray.opacity(0.2))

                    NutrientInputInt(title: "Calories", value: $dish.calories, isEditing: isEditing)
                    NutrientInput(title: "Carbs", value: $dish.carbs, isEditing: isEditing)
                    NutrientInput(title: "Protein", value: $dish.protein, isEditing: isEditing)
                    NutrientInput(title: "Fat", value: $dish.fat, isEditing: isEditing)
                    NutrientInputOptional(title: "Fiber", value: $dish.fiber, isEditing: isEditing)
                    NutrientInputOptional(title: "Sugar", value: $dish.sugar, isEditing: isEditing)
                    NutrientInputOptional(title: "Saturated Fat", value: $dish.saturatedFat, isEditing: isEditing)
                    NutrientInputOptional(title: "Cholesterol", value: $dish.cholesterol, isEditing: isEditing)
                    NutrientInputOptional(title: "Sodium", value: $dish.sodium, isEditing: isEditing)

                    // TODO:
                }
                .padding()
                .background(Color(.white))
                .cornerRadius(16)
                .shadow(radius: 3)
                .frame(maxWidth: 600)

                actionButtons
            }
            .padding()
        }

        .navigationTitle(dish.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    withAnimation {
                        isEditing.toggle()
                    }
                } label: {
                    Image(systemName: "pencil")
                }

                Button {
                    dish.saved.toggle()
                    try? modelContext.save()
                } label: {
                    Image(systemName: dish.saved ? "bookmark.fill" : "bookmark")
                }
            }
        }
    }

    func loadNewDishImage() {
        Task {
            guard let data = try? await imageSelection?.loadTransferable(type: Data.self) else { return }
            if let imageData = UIImage(data: data)?.jpegData(compressionQuality: 0.8) {
                dish.image = imageData
            }
        }
    }

    @ViewBuilder var image: some View {
        if let imageData = dish.image, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .cornerRadius(12)
        } else {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 150, height: 150)
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                )
                .frame(maxWidth: .infinity)
        }

        if isEditing {
            PhotosPicker(selection: $imageSelection, matching: .images) {
                Text("Choose Image")
                    .foregroundColor(.blue)
                    .bold()
            }
            .onChange(of: imageSelection) {
                loadNewDishImage()
            }
        }
    }

    @ViewBuilder var actionButtons: some View {
        if isEditing {
            Button("Save") {
                try? modelContext.save()
                isEditing = false
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(12)
        }

        Button {
            modelContext.delete(dish)
            dismiss()
        } label: {
            Text("Delete")
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
        .padding(.top, -15)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }

    @ViewBuilder var NutrientStringInputs: some View {
        HStack {
            Text("Serving Size")
            Spacer()
            TextField("100", value: $dish.servingSize, format: .number)
                .keyboardType(.decimalPad)
                .disabled(!isEditing)
                .textFieldStyle(.roundedBorder)
                .frame(width: 80)
        }

        HStack {
            Text("Serving Type")
            Spacer()
            if isEditing {
                Picker("Serving Type", selection: $dish.servingType) {
                    ForEach(Dish.ServingType.allCases, id: \.self) { type in
                        Text("\(type)")
                            .tag(type)
                    }
                }
                .pickerStyle(.menu)
            } else {
                Text("\(dish.servingType)")
            }
        }
    }
}

struct NutrientInputOptional: View {
    var title: String
    @Binding var value: Double?
    var isEditing: Bool

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            if isEditing {
                let binding = Binding<Double>(
                    get: { value ?? 0 },
                    set: { value = $0 }
                )
                TextField("0", value: binding, format: .number)
                    .keyboardType(.decimalPad)
                    .frame(width: 60)
            } else {
                Text("\(value ?? 0, specifier: "%.1f")")
            }
        }
        .padding(.vertical, 4)
    }
}

struct NutrientInput: View {
    var title: String
    @Binding var value: Double
    var isEditing: Bool

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            if isEditing {
                TextField("0", value: $value, format: .number)
                    .keyboardType(.decimalPad)
                    .frame(width: 60)
            } else {
                Text("\(value ?? 0, specifier: "%.1f")")
            }
        }
        .padding(.vertical, 4)
    }
}

struct NutrientInputInt: View {
    var title: String
    @Binding var value: Int
    var isEditing: Bool

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            if isEditing {
                TextField("0", value: $value, format: .number)
                    .keyboardType(.decimalPad)
                    .frame(width: 60)
            } else {
                Text("\(value ?? 0, specifier: "%.1f")")
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    let sampleDish = Dish(
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
        vitamins: ["Vitamin A": 20.0, "Vitamin C": 15.0], minerals: ["Calcium": 8.0, "Iron": 10.0], servingSize: 350.0, servingType: .bowl
    )
    DishEditView(dish: sampleDish)
}
