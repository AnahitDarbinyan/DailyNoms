//
//  ActivityLevelSelectorView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 13.06.25.
//

import SwiftUI

struct ActivityLevelSelectorView: View {
    @Binding var activitylevel: Snapshot.ActivityLevel
    @State private var selectedLevel: Snapshot.ActivityLevel = .moderatelyActive
    @State private var isPressed = false
    var onSubmit: () -> Void
    var onBack: () -> Void

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            RoundedRectangle(cornerRadius: 50)
                .fill(Color("MidnightPurple"))
                .scaleEffect(1)
                .offset(y: -getRect().height / 1.8)

            VStack(spacing: 0) {
                Image("Activitylevel")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 450, height: 650)
                    .frame(maxHeight: 300)
                    .padding(.top, 120)

                Spacer(minLength: 80)

                Text("Select your activity level")
                    .font(.system(size: 31, weight: .bold, design: .serif))
                    .foregroundColor(Color("MidnightPurple"))
                    .padding(.vertical, 20)
                    .offset(y: 50)

                // Picker in the middle
                Picker("Activity Level", selection: $selectedLevel) {
                    ForEach(Snapshot.ActivityLevel.allCases, id: \.self) { level in
                        Text(levelDisplayName(level))
                            .font(.system(size: selectedLevel == level ? 24 : 20, weight: .semibold))
                            .foregroundColor(Color("MidnightPurple"))
                            .opacity(selectedLevel == level ? 1.0 : 0.4)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 250)
                .clipped()
                .padding(.horizontal)

                Spacer()

                Button(action: {
                    print("Submit pressed")
                    isPressed = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        isPressed = false
                        activitylevel = selectedLevel
                        onSubmit()
                    }
                }) {
                    Text("Submit")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isPressed ? Color.gray : Color("MidnightPurple"))
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                        .shadow(color: Color.purple.opacity(0.2), radius: 10, x: 0, y: 2)
                }
                .padding(.horizontal, 70)
                .padding(.bottom, 140)
            }
            .onAppear {
                selectedLevel = activitylevel
            }
        }
    }

    private func levelDisplayName(_ level: Snapshot.ActivityLevel) -> String {
        switch level {
        case .sedentary: return "Sedentary"
        case .lightlyActive: return "Lightly Active"
        case .moderatelyActive: return "Moderately Active"
        case .veryActive: return "Very Active"
        case .extraActive: return "Extra Active"
        }
    }
}

struct ActivityLevelSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityLevelSelectorView(
            activitylevel: Binding.constant(Snapshot.ActivityLevel.moderatelyActive),
            onSubmit: {},
            onBack: {}
        )
    }
}
