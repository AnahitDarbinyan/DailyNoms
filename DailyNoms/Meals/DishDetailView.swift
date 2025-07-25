//
//  DishDetailView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 30.05.25.
//

import PhotosUI
import SwiftData
import SwiftUI

struct DishDetailView: View {
    var dish: Dish
    @Environment(\.modelContext) private var modelContext: ModelContext
    @State var imageSelection: PhotosPickerItem? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let image = dish.image {
                #if canImport(UIKit)
                    let uiImage = UIImage(data: image)!
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                #elseif canImport(AppKit)
                    let nsImage = NSImage(data: image)!
                    Image(nsImage: nsImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                #endif

            } else {
                PhotosPicker(selection: $imageSelection,
                             matching: .images,
                             photoLibrary: .shared())
                {
                    Image(systemName: "pencil.circle.fill")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 30))
                        .foregroundColor(.accentColor)
                }
                .buttonStyle(.borderless)
                .onChange(of: imageSelection, loadImage)
            }
            Text(dish.name)
                .font(.largeTitle)
                .bold()

            HStack(spacing: 20) {
//                CircularCalorieView(carbs: dish.carbs, protein: dish.protein, fat: dish.fat)

                VStack(alignment: .leading, spacing: 8) {
                    NutrientRow(color: .red, name: "Carbs", value: dish.carbs, percentage: 37.2)

                    NutrientRow(color: .orange, name: "Protein", value: dish.protein, percentage: 18.8)

                    NutrientRow(color: .blue, name: "Fat", value: dish.fat, percentage: 44.0)
                }
            }
            .padding(.horizontal)

            Divider()

            VStack(alignment: .leading, spacing: 12) {
                if let fiber = dish.fiber {
                    InfoLine(title: "Fiber", value: fiber, unit: "g")
                }
                if let sugar = dish.sugar {
                    InfoLine(title: "Sugar", value: sugar, unit: "g")
                }
                if let saturatedFat = dish.saturatedFat {
                    InfoLine(title: "Saturated Fat", value: saturatedFat, unit: "g")
                }
                if let cholesterol = dish.cholesterol {
                    InfoLine(title: "Cholesterol", value: cholesterol, unit: "mg")
                }
                if let sodium = dish.sodium {
                    InfoLine(title: "Sodium", value: sodium, unit: "mg")
                }
                if let vitamins = dish.vitamins {
                    ForEach(vitamins.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                        InfoLine(title: key, value: value, unit: "mg")
                    }
                }
                if let minerals = dish.minerals {
                    ForEach(minerals.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                        InfoLine(title: key, value: value, unit: "mg")
                    }
                }
            }
            .padding(.top)

            Text("Serving Size: \(dish.servingSize)")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.top, 12)

            Text("Serving Type: \(dish.servingType)")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.top, 8)

            if let user = dish.user {
                Text("Added)")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.top, 20)
            }
        }
        .toolbar {
            Button {
                dish.favorite.toggle()
                try? modelContext.save()
            } label: {
                Image(systemName: dish.favorite ? "heart.fill" : "heart")
            }
        }
        .padding()
    }

    func loadImage() {
        Task {
            guard let data = try await imageSelection?.loadTransferable(type: Data.self) else { return }
            #if canImport(UIKit)
                guard let imageData = UIImage(data: data)?.pngData() else { return }
            #elseif canImport(AppKit)
                guard let nsImage = NSImage(data: data)? else { return }
                guard let cgImage = nsImage.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
                    return nil
                }

                let bitmapRepresentation = NSBitmapImageRep(cgImage: cgImage)
                let imageData = bitmapRepresentation.representation(using: .png, properties: [:])

            #endif
            dish.image = imageData
        }
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
    DishDetailView(dish: sampleDish)
}
