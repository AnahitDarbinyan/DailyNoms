//
//  RadialBarView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 31.05.25.
//

import SwiftUI

struct RadialBarView: View {
    var progress: Double
    var color: Color
    var lineWidth: CGFloat
    var radius: CGFloat

    var body: some View {
        Circle()
            .stroke(color.opacity(0.1), lineWidth: lineWidth)
            .frame(width: radius * 2, height: radius * 2)
            .overlay(
                Circle()
                    .trim(from: 0, to: CGFloat(progress))
                    .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .rotationEffect(.degrees(-90))
            )
    }
}

#Preview {
    RadialBarView(progress: 0.87, color: .red, lineWidth: 7, radius: 20)
}
