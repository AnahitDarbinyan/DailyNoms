//
//  SplashScreenView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 26.05.25.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color("MidnightPurple")
                .ignoresSafeArea()

            Image(.clouds)
                .resizable()
                .scaledToFit()
                .frame(width: 850, height: 850)

            Image(.character)
                .resizable()
                .scaledToFit()
                .frame(width: 550, height: 550)

            Text("DailyNoms")
                .font(.system(size: 25, weight: .semibold, design: .rounded)).opacity(0.8)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .bottom)
                .position(x: 440, y: 810)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("MidnightPurple"))
    }
}

#Preview {
    SplashScreenView()
}
