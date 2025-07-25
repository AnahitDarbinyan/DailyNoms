//
//  BackButton.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 13.06.25.
//

import SwiftUI

struct BackButton: View {
    var action: () -> Void

    var body: some View {
        HStack {
            Button(action: action) {
                HStack(spacing: 4) {
                    Image(systemName: "arrowshape.backward.fill")
                    Text("Back")
                }
                .foregroundColor(.white)
                .font(.headline)
            }
            Spacer()
        }
        .padding(.top, 16)
        .padding(.leading, 16)
        .padding(.horizontal)
    }
}

#Preview {
    BackButton {
        print("Back tapped")
    }
}
