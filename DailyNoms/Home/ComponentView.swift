//
//  ComponentView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 31.05.25.
//

import SwiftUI

struct ComponentView: View {
    var title: String
    var current: Int
    var total: Int
    var color: Color

    var body: some View {
        HStack {
            RadialBarView(progress: Double(current) / Double(total), color: color, lineWidth: 7, radius: 17.5)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(color)
                Text("\(current)g")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(color.opacity(0.6))
            }
        }
        .frame(maxWidth: 100)
    }
}

#Preview {
    ComponentView(title: "Protein", current: 134, total: 200, color: .red)
}
