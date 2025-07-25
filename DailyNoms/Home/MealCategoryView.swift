//
//  MealCategoryView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 01.06.25.
//

// import SwiftData
// import SwiftUI
//
// extension Meal.Kind {
//    var image: Image { switch self {
//    case .breakfast:
//        Image(.breakfast2)
//    case .lunch:
//        Image(.lunch2)
//    case .dinner:
//        Image(.dinner2)
//    case .snack:
//        Image(.snack2)
//    }
//    }
//
//    var color: Color { switch self {
//    case .breakfast:
//        Color("CustomPurple")
//    case .lunch:
//        Color("CustomPurple")
//    case .dinner:
//        Color("CustomPurple")
//    case .snack:
//        Color("CustomPurple")
//    }
//    }
// }
//
// struct MealCategoryView: View {
//    @Query var users: [User]
//    @Query var allMeals: [Meal]
//    var lineWidth: CGFloat = 5
//    var user: User {
//        users.first ?? User(name: "Preview", age: 25, gender: .female)
//    }
//
//    func calories(for type: Meal.Kind) -> Int {
//        allMeals
//            .filter { $0.mealtype == type }
//            .reduce(0) { $0 + $1.calories }
//    }
//
//    init(date: Date) {
//        _allMeals = Query(filter: Meal.at(date: date))
//    }
//
//    var body: some View {
//        VStack(spacing: 40) {
//            HStack(spacing: 40) {
//                entry(mealType: .breakfast)
//                entry(mealType: .dinner)
//            }
//
//            HStack(spacing: 40) {
//                entry(mealType: .lunch)
//                entry(mealType: .snack)
//            }
//        }
//        .frame(maxWidth: .infinity)
//    }
//
//    func entry(mealType: Meal.Kind) -> some View {
//        ZStack(alignment: .bottomTrailing) {
//            VStack(alignment: .center) {
//                Text(mealType.rawValue)
//                    .bold()
//                    .font(.system(.body, design: .serif))
////                    .foregroundColor(.)
//                ZStack {
//                    Circle()
//                        .stroke(mealType.color.opacity(0.1), lineWidth: lineWidth)
//                        .frame(width: 80, height: 80)
//
//                    Circle()
//                        .stroke(mealType.color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
//                        .frame(width: 80, height: 80)
//
//                    mealType.image
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 50, height: 50)
//                }
//                Text("\(calories(for: mealType)) kcal")
//                    .font(.headline)
//                    .foregroundColor(.gray)
//            }
//
//            NavigationLink(destination: MealSearchView(mealType: mealType)) {
//                Image(systemName: "plus.circle.fill")
//                    .font(.system(size: 20, weight: .bold))
//                    .foregroundColor(.white)
//                    .frame(width: 25, height: 30)
//                    .background(Color("MidnightPurple"))
//                    .clipShape(Circle())
//                    .padding(6)
//                    .offset(x: -69, y: 10)
//            }
//        }
//        .buttonStyle(.plain)
//        .frame(width: 110, height: 110)
//    }
// }
//
// #Preview {
//    MealCategoryView(date: Date())
// }
// import SwiftData
// import SwiftUI
//
// extension Meal.Kind {
//    var image: Image { switch self {
//    case .breakfast:
//        Image(.breakfast4)
//    case .lunch:
//        Image(.lunch4)
//    case .dinner:
//        Image(.dinner4)
//    case .snack:
//        Image(.snack4)
//    }
//    }
//
//    var color: Color { switch self {
//    case .breakfast:
//        Color("random")
//    case .lunch:
//        Color("random")
//    case .dinner:
//        Color("random")
//    case .snack:
//        Color("random")
//    }
//    }
// }
//
// struct MealCategoryView: View {
//    @Query var users: [User]
//    @Query var allMeals: [Meal]
//    var user: User {
//        users.first ?? User(name: "Preview", age: 25, gender: .female)
//    }
//
//    func calories(for type: Meal.Kind) -> Int {
//        allMeals
//            .filter { $0.mealtype == type }
//            .reduce(0) { $0 + $1.calories }
//    }
//
//    init(date: Date) {
//        _allMeals = Query(filter: Meal.at(date: date))
//    }
//
//    var body: some View {
//        VStack(spacing: 15) {
//            mealCard(mealType: .breakfast)
//            Divider()
//            mealCard(mealType: .lunch)
//            Divider()
//            mealCard(mealType: .dinner)
//            Divider()
//            mealCard(mealType: .snack)
//        }
//        .frame(maxWidth: .infinity)
//        .padding(.vertical, 10)
//    }
//
//    func mealCard(mealType: Meal.Kind) -> some View {
//        HStack(spacing: 10) {
//            mealType.image
//                .resizable()
//                .scaledToFit()
//                .frame(width: 60, height: 60)
//
//            VStack(alignment: .leading, spacing: 5) {
//                Text(mealType.rawValue)
//                    .font(.system(.body, design: .rounded))
//                    .fontWeight(.heavy)
//                    .foregroundColor(mealType.color)
//                Text("\(calories(for: mealType)) / 768 kcal")
//                    .font(.headline)
//                    .foregroundColor(.gray)
//            }
//
//            Spacer()
//
//            Image(systemName: "plus")
//                .foregroundColor(.green)
//                .font(.system(size: 20, weight: .bold))
//        }
//        .padding(.horizontal, 10)
//    }
// }
//
// #Preview {
//    MealCategoryView(date: Date())
// }

import SwiftData
import SwiftUI

extension Meal.Kind {
    var image: Image {
        switch self {
        case .breakfast: Image(.breakfast4)
        case .lunch: Image(.lunch4)
        case .dinner: Image(.dinner4)
        case .snack: Image(.snack4)
        }
    }

    var color: Color {
        switch self {
        case .breakfast:
            Color("random")
        case .lunch:
            Color("random")
        case .dinner:
            Color("random")
        case .snack:
            Color("random")
        }
    }
}

struct MealCategoryView: View {
    @Query var users: [User]
    @Query var allMeals: [Meal]
    var user: User { users.first ?? User(name: "Preview", age: 25, gender: .female) }

    func calories(for type: Meal.Kind) -> Int {
        allMeals
            .filter { $0.mealtype == type }
            .reduce(0) { $0 + $1.calories }
    }

    var totalCaloriesPerCategory: Int {
        let total = allMeals.reduce(0) { $0 + $1.calories }
        return Int(total / 4) // Total calories divided by 4, rounded to integer
    }

    init(date: Date) {
        _allMeals = Query(filter: Meal.at(date: date))
    }

    var body: some View {
        VStack(spacing: 15) {
            mealCard(mealType: .breakfast)
            Divider()
            mealCard(mealType: .lunch)
            Divider()
            mealCard(mealType: .dinner)
            Divider()
            mealCard(mealType: .snack)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
    }

    func mealCard(mealType: Meal.Kind) -> some View {
        HStack(spacing: 10) {
            mealType.image
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)

            VStack(alignment: .leading, spacing: 5) {
                Text(mealType.rawValue)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.heavy)
                    .foregroundColor(mealType.color)
                Text("\(calories(for: mealType)) / \(totalCaloriesPerCategory) kcal")
                    .font(.headline)
                    .foregroundColor(.gray)
            }

            Spacer()

            NavigationLink(destination: MealSearchView(mealType: mealType)) {
                Image(systemName: "plus")
                    .foregroundColor(.green)
                    .font(.system(size: 20, weight: .bold))
            }
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    MealCategoryView(date: Date())
}
