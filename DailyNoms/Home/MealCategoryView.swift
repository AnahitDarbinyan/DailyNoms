//
//  MealCategoryView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 01.06.25.
//

import SwiftData
import SwiftUI

extension Meal.Kind {
    var image: Image { switch self {
    case .breakfast:
        Image(.breakfast)
    case .lunch:
        Image(.lunch)
    case .dinner:
        Image(.dinner)
    case .snack:
        Image(.snacks)
    }
    }

    var color: Color { switch self {
    case .breakfast:
        Color(.green)
    case .lunch:
        Color(.red)
    case .dinner:
        Color(.orange)
    case .snack:
        Color(.yellow)
    }
    }
}

struct MealCategoryView: View {
    @Query var allMeals: [Meal]
    var lineWidth: CGFloat = 10

    func calories(for type: Meal.Kind) -> Int {
        allMeals
            .filter { $0.mealtype == type }
            .reduce(0) { $0 + $1.calories }
    }

    init(date: Date) {
        _allMeals = Query(filter: Meal.at(date: date))
    }

    var body: some View {
        VStack(spacing: 40) {
            HStack(spacing: 40) {
                entry(meal: .breakfast)
                entry(meal: .dinner)
            }

            HStack(spacing: 40) {
                entry(meal: .lunch)
                entry(meal: .snack)
            }
        }
        .frame(maxWidth: .infinity)
    }

    func entry(meal: Meal.Kind) -> some View {
        return NavigationLink(destination: FilteredMealListView(kind: meal)) {
            VStack(alignment: .center) {
                Text(meal.rawValue)
                    .bold()
                ZStack {
                    Circle()
                        .stroke(meal.color.opacity(0.1), lineWidth: lineWidth)
                        .frame(width: 80, height: 80)

                    Circle()
                        .stroke(meal.color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                        .frame(width: 80, height: 80)

                    meal.image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
            }
        }
    }
}

#Preview {
    MealCategoryView()
}
