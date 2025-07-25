//
//  GenderSelectionView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 13.06.25.
//

import SwiftUI

struct GenderSelectionView: View {
    @State private var selectedGender: User.Gender? = nil
    @Binding var gender: User.Gender
    var onNext: () -> Void
    var onBack: () -> Void
    @State private var isPressed = false

    var body: some View {
        VStack(spacing: 40) {
            Text("Select your gender")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.top, 50)
                .foregroundColor(Color("MidnightPurple"))

            VStack(spacing: 30) {
                GenderOptionView(
                    gender: .male,
                    imageName: "male",
                    isSelected: selectedGender == .male
                )
                .onTapGesture {
                    selectedGender = .male
                    gender = .male
                }

                GenderOptionView(
                    gender: .female,
                    imageName: "female",
                    isSelected: selectedGender == .female
                )
                .onTapGesture {
                    selectedGender = .female
                    gender = .female
                }
            }

            Spacer()

            Button(action: {
                isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    isPressed = false
                    //                print("Selected gender: \(selectedGender?.rawValue ?? "No Gender Selected")")
                }
                onNext()
            }) {
                Text("Continue")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 80)
                    .background(isPressed ? Color.gray : Color("MidnightPurple"))
                    .clipShape(Capsule())
                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                    .shadow(color: Color.purple.opacity(0.2), radius: 10, x: 0, y: 2)
                    .offset(x: 0, y: 30)
            }
            .disabled(selectedGender == nil)
            .padding(.bottom, 20)
        }
        .padding()
    }
}

struct GenderOptionView: View {
    var gender: User.Gender
    var imageName: String
    var isSelected: Bool

    var body: some View {
        VStack(spacing: 12) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 180)

            Text(gender.rawValue)
                .font(.headline)
                .foregroundColor(Color("MidnightPurple"))
        }
        .padding()
        .frame(width: 200, height: 230)
        .background(isSelected ? Color.purple.opacity(0.2) : Color.gray.opacity(0.1))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isSelected ? Color.purple : Color.clear, lineWidth: 2)
        )
    }
}

struct GenderSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        GenderSelectionView(gender: .constant(.male), onNext: {}, onBack: {})
    }
}
