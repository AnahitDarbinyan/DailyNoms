//
//  CalorieProgressView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 31.05.25.
//

import SwiftUI

struct CalorieProgressView: View {
    var remaining: Int
    var current: Int
    var color = Color.green
    var body: some View {
        
        RadialBarView(progress: Double(remaining)/Double(remaining + current), color: color, lineWidth: 15, radius: 100)
            .overlay{
                VStack{
                    Text("\(remaining)")
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                        .foregroundStyle(color)
                    Text("kcal remaining")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundStyle(color.opacity(0.6))
                }
            }
        
    }
    
}

#Preview {
    CalorieProgressView(remaining: 4000, current: 5000)
}
