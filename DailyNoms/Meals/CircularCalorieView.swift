//
//  CircularCalorieView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 14.06.25.
//

import SwiftUI

struct CircularCalorieView: View {
    var carbs: Double
    var protein: Double
    var fat: Double

    private var total: Double {
        carbs + protein + fat
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 10)

            Circle()
                .trim(from: 0, to: CGFloat(carbs / total))
                .stroke(Color.red, lineWidth: 10)
                .rotationEffect(.degrees(-90))

            Circle()
                .trim(from: CGFloat(carbs / total), to: CGFloat((carbs + protein) / total))
                .stroke(Color.orange, lineWidth: 10)
                .rotationEffect(.degrees(-90))

            Circle()
                .trim(from: CGFloat((carbs + protein) / total), to: 1)
                .stroke(Color.blue, lineWidth: 10)
                .rotationEffect(.degrees(-90))

            VStack {
                Text("\(Int(total))")
                    .font(.title)
                    .bold()
                Text("kcal")
                    .font(.caption)
            }
        }
        .frame(width: 100, height: 100)
    }
}

struct NutrientRow: View {
    var color: Color
    var name: String
    var value: Double
    var percentage: Double

    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(name)
                .font(.subheadline)
            Spacer()
            Text("\(String(format: "%.1f", value)) (\(Int(percentage))%)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

struct InfoLine: View {
    var title: String
    var value: Double
    var unit: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text("\(Int(value)) \(unit)")
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    CircularCalorieView(carbs: 3.4, protein: 132.5, fat: 56.4)
}
