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
    @Query var users: [User]
    @Query var allMeals: [Meal]
    var lineWidth: CGFloat = 10
    var user: User {
        users.first ?? User(name: "Preview", age: 25, gender: .female)
    }

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
                entry(mealType: .breakfast)
                entry(mealType: .dinner)
            }

            HStack(spacing: 40) {
                entry(mealType: .lunch)
                entry(mealType: .snack)
            }
        }
        .frame(maxWidth: .infinity)
    }

    func entry(mealType: Meal.Kind) -> some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .center) {
                Text(mealType.rawValue)
                    .bold()
                ZStack {
                    Circle()
                        .stroke(mealType.color.opacity(0.1), lineWidth: lineWidth)
                        .frame(width: 80, height: 80)

                    Circle()
                        .stroke(mealType.color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                        .frame(width: 80, height: 80)

                    mealType.image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
            }

            NavigationLink(destination: MealSearchView(mealType: mealType)) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .background(Color("Green"))
                    .clipShape(Circle())
                    .padding(6)
                    .offset(x: -69, y: 38)
            }
        }
        .buttonStyle(.plain)
        .frame(width: 100, height: 120)
    }
}

#Preview {
    MealCategoryView(date: Date())
}
