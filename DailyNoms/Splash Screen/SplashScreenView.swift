//
//  SplashScreenView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 26.05.25.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        VStack {
            Image(.logopic)
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.teal)
    }
}

#Preview {
    SplashScreenView()
}
