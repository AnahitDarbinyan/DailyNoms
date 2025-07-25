//
//  NameInputView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 05.06.25.
//

import SwiftData
import SwiftUI

struct NameInputView: View {
    @Binding var name: String
    var onNext: () -> Void
    @State private var isPressed = false

    var body: some View {
        VStack {
            ZStack(alignment: .center) {
                Image(.clouds)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 850, height: 850)

                Image(.namePage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 400)
            }
            .background(Color("MidnightPurple"))
            .frame(maxWidth: 410, maxHeight: 500)
            .clipShape(RoundedRectangle(cornerRadius: 50))
            .ignoresSafeArea(.container)

            VStack(spacing: 24) {
                Text("What's your name?")
                    .font(.title)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.heavy)
                    .foregroundColor(Color("MidnightPurple"))

                TextField("", text: $name)
                    .padding()
                    .font(.title3)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("MidnightPurple"), lineWidth: 2)
                    )
                    .padding(.horizontal, 50)

                Button(action: {
                    isPressed = true
                    // Animate back to normal after a short delay, then call onNext
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        isPressed = false
                        onNext()
                    }
                }, label: {
                    Text("Continue")
                        .font(.title2)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 70)
                        .background(isPressed ? Color.gray : Color("MidnightPurple"))
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                        .shadow(color: Color.purple.opacity(0.2), radius: 10, x: 0, y: 2)
                })
//                .padding(.vertical, 70)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    NameInputView(name: .constant("Anahit"), onNext: {})
}
