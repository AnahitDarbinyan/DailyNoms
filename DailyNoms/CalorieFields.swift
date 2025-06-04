//
//  CalorieFields.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 24.05.25.
//

import SwiftUI

struct CalorieFields: View {
    @Binding var dish: String
    @Binding var calories: Int
    
    
    var body: some View {
        Form{
            LabeledContent {
                TextField("Dish", text: $dish)
            } label: {
                Text("Dish")
            }
            LabeledContent {
                TextField("Calories", value: $calories, format: .number)
            } label: {
                Text("Calories")
            }
        }
    }
}

#Preview {
    CalorieFields(dish:.constant(""), calories: .constant(0))
}
