//
//  AgePickerView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 13.06.25.
//

import SwiftUI

struct AgePickerView: View {
    @Binding var selectedAge: Int
    private let ages = Array(0 ... 100)
    var onNext: () -> Void
    var onBack: () -> Void

    var body: some View {
        ZStack {
            Color("MidnightPurple")
                .ignoresSafeArea()

            VStack {
                Text("Select your age")
                    .font(.system(size: 34, weight: .bold, design: .serif))
                    .foregroundColor(.white)
                    .padding(.top, 40)

                Picker(selection: $selectedAge, label: Text("Age")) {
                    ForEach(ages, id: \.self) { age in
                        Text("\(age)")
                            .font(.system(size: selectedAge == age ? 45 : 28, weight: .bold))
                            .foregroundColor(.white)
                            .opacity(selectedAge == age ? 1.0 : 0.4)
                            .frame(maxWidth: .infinity)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 200)
                .clipped()

                Button(action: {
                    onNext()
                }) {
                    Text("Continue")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 70)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Capsule())
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                }

                Spacer()
            }
            .padding()
        }
    }
}

struct AgePickerView_Previews: PreviewProvider {
    static var previews: some View {
        AgePickerView(selectedAge: .constant(25), onNext: {}, onBack: {})
    }
}
