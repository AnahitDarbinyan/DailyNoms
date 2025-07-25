//
//  AddDishView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 15.06.25.
//

import PhotosUI
import SwiftData
import SwiftUI

struct AddDishView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Query var users: [User]

    @State private var name = ""
    @State private var calories: Int?
    @State private var fat: Double?
    @State private var saturatedFat: Double?
    @State private var cholesterol: Double?
    @State private var sodium: Double?
    @State private var carbs: Double?
    @State private var fiber: Double?
    @State private var sugar: Double?
    @State private var protein: Double?
    @State private var vitamins: [String: Double] = [:]
    @State private var minerals: [String: Double] = [:]
    @State private var servingSize: String = ""
    @State private var servingType: Dish.ServingType = .plate
    @State private var selectedImageData: Data?
    @State private var selectedPhoto: PhotosPickerItem?

    var user: User? { users.first }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    photoPickerSection
                    nutritionalInfoSection
                    saveButton
                }
                .padding()
            }
            .navigationTitle("Add Dish")
            .onChange(of: selectedPhoto) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                    }
                }
            }
        }
    }

    private var photoPickerSection: some View {
        VStack {
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                if let imageData = selectedImageData, let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray.opacity(0.4), lineWidth: 1))
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 120, height: 120)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                        )
                }
            }
            Text("Choose Photo")
                .font(.headline)
        }
    }

    private var nutritionalInfoSection: some View {
        Group {
            TextField("Dish Name", text: $name)
            TextField("Calories", value: $calories, format: .number)
            TextField("Fat (g)", value: $fat, format: .number)
            TextField("Saturated Fat (g)", value: $saturatedFat, format: .number)
            TextField("Cholesterol (mg)", value: $cholesterol, format: .number)
            TextField("Sodium (mg)", value: $sodium, format: .number)
            TextField("Carbs (g)", value: $carbs, format: .number)
            TextField("Fiber (g)", value: $fiber, format: .number)
            TextField("Sugar (g)", value: $sugar, format: .number)
            TextField("Protein (g)", value: $protein, format: .number)
            TextField("Serving Size (e.g. 100g)", text: $servingSize)

            Picker("Serving Type", selection: $servingType) {
                ForEach(Dish.ServingType.allCases, id: \.self) { type in
                    Text(type.rawValue.capitalized).tag(type)
                }
            }
            .pickerStyle(.segmented)
        }
        .textFieldStyle(.roundedBorder)
        .keyboardType(.decimalPad)
    }

    private var saveButton: some View {
        Button("Save Dish") {
            saveDish()
        }
        .buttonStyle(SaveButtonStyle())
    }

    private func saveDish() {
        guard let calories = calories else { return }

        let newDish = Dish(
            name: name,
            calories: calories,
            user: user,
            fat: fat ?? 0,
            saturatedFat: saturatedFat,
            cholesterol: cholesterol,
            sodium: sodium,
            carbs: carbs ?? 0,
            fiber: fiber,
            sugar: sugar,
            protein: protein ?? 0,
            vitamins: vitamins.isEmpty ? nil : vitamins,
            minerals: minerals.isEmpty ? nil : minerals,
            servingSize: Double(servingSize) ?? 100.0,
            servingType: servingType
        )

        newDish.image = selectedImageData
        newDish.createdByUser = true

        modelContext.insert(newDish)
        try? modelContext.save()
        dismiss()
    }
}

struct SaveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

#Preview {
    AddDishView()
        .modelContainer(for: [Dish.self, User.self])
}

// import SwiftUI
// import SwiftData
// import PhotosUI
//
// struct AddDishView: View {
//    @Environment(\.dismiss) var dismiss
//    @Environment(\.modelContext) var modelContext
//    @Query var users: [User]
//
//    @State private var name = ""
//    @State private var calories: Int?
//    @State private var fat: Double?
//    @State private var saturatedFat: Double?
//    @State private var cholesterol: Double?
//    @State private var sodium: Double?
//    @State private var carbs: Double?
//    @State private var fiber: Double?
//    @State private var sugar: Double?
//    @State private var protein: Double?
//    @State private var vitamins: [String: Double] = [:]
//    @State private var minerals: [String: Double] = [:]
//    @State private var servingSize: String = ""
//    @State private var servingType: ServingType = .plate
//    @State private var selectedImageData: Data?
//    @State private var selectedPhoto: PhotosPickerItem?
//
//    var user: User? { users.first }
//
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                VStack(spacing: 20) {
//                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
//                        if let imageData = selectedImageData, let image = UIImage(data: imageData) {
//                            Image(uiImage: image)
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 120, height: 120)
//                                .clipShape(Circle())
//                                .overlay(Circle().stroke(Color.gray.opacity(0.4), lineWidth: 1))
//                        } else {
//                            Circle()
//                                .fill(Color.gray.opacity(0.3))
//                                .frame(width: 120, height: 120)
//                                .overlay(Image(systemName: "photo").font(.largeTitle).foregroundColor(.gray))
//                        }
//                    }
//                    Text("Choose Photo")
//                        .font(.headline)
//
//                    Group {
//                        TextField("Dish Name", text: $name)
//                        TextField("Calories", value: $calories, format: .number)
//                        TextField("Fat (g)", value: $fat, format: .number)
//                        TextField("Saturated Fat (g)", value: $saturatedFat, format: .number)
//                        TextField("Cholesterol (mg)", value: $cholesterol, format: .number)
//                        TextField("Sodium (mg)", value: $sodium, format: .number)
//                        TextField("Carbs (g)", value: $carbs, format: .number)
//                        TextField("Fiber (g)", value: $fiber, format: .number)
//                        TextField("Sugar (g)", value: $sugar, format: .number)
//                        TextField("Protein (g)", value: $protein, format: .number)
//                        TextField("Serving Size (e.g. 100g)", text: $servingSize)
//                        Picker("Serving Type", selection: $servingType) {
//                            ForEach(Dish.ServingType.allCases, id: \.self) { type in
//                                Text(type.description.capitalized).tag(type)
//                            }
//                        }
//                        .pickerStyle(.segmented)
//                    }
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .keyboardType(.decimalPad)
//
//                    Button("Save Dish") {
//                        guard let calories = calories else { return }
//                        let newDish = Dish(
//                            name: name,
//                            calories: calories,
//                            user: user,
//                            fat: fat,
//                            saturatedFat: saturatedFat,
//                            cholesterol: cholesterol,
//                            sodium: sodium,
//                            carbs: carbs,
//                            fiber: fiber,
//                            sugar: sugar,
//                            protein: protein,
//                            vitamins: vitamins,
//                            minerals: minerals,
//                            servingSize: servingSize,
//                            servingType: servingType
//                        )
//                        newDish.image = selectedImageData
//                        newDish.createdByUser = true
//                        modelContext.insert(newDish)
//                        try? modelContext.save()
//                        dismiss()
//                    }
//                    .padding()
//                    .foregroundColor(.white)
//                    .background(Color.green)
//                    .cornerRadius(10)
//                }
//                .padding()
//            }
//            .navigationTitle("Add Dish")
//            .onChange(of: selectedPhoto) { newItem in
//                Task {
//                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
//                        selectedImageData = data
//                    }
//                }
//            }
//        }
//    }
// }
//
//
// #Preview {
//    AddDishView()
// }
