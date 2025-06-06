//
//  NameInputView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 05.06.25.
//

import SwiftData
import SwiftUI

struct NameInputView: View {
    @Query var users: [User]
//    var user: User { users.first! }
    var user: User {
        users.first ?? User(name: "Default", age: 0, gender: .male)
    }

    @Environment(\.modelContext) private var modelContext
    @State var name: String = ""
    var onNext: () -> Void = {}

    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .fill(Color("MidnightPurple"))
                    .frame(width: 410, height: 800)
                    .offset(x: 0, y: -120)

                Image(.clouds)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 850, height: 850)
                    .offset(x: 0, y: 130)

                Image(.namePage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 400)
                    .offset(x: 0, y: 50)
            }
            .frame(maxWidth: .infinity)

            VStack(spacing: 24) {
                Text("What's your name?")
                    .font(.title)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.heavy)
                    .foregroundColor(Color("MidnightPurple"))
                    .offset(x: 0, y: -100)

                TextField("", text: $name)
                    .padding()
                    .font(.title3)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("MidnightPurple"), lineWidth: 2)
                    )
                    .padding(.horizontal, 50)
                    .offset(x: 0, y: -100)

                Button(action: {
                    user.name = name
                    try? modelContext.save()
                    onNext()
                }, label: {
                    Text("Continue")
                        .font(.title2)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 70)
                        .background(Color("MidnightPurple"))
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                        .shadow(color: Color.purple.opacity(0.2), radius: 10, x: 0, y: 2)
                        .offset(x: 0, y: -130)
                })
                .padding(.vertical, 70)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            name = user.name
        }
    }
}

#Preview {
    NameInputView()
}
