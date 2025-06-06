//
//  HeightPickerView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 05.06.25.
//

import AudioUnit
import SwiftUI

struct HeightPickerView: View {
    @State var offset: CGFloat = 0
    var onNext: () -> Void
    let startHeight = 120
    let endHeight = 250
    let step = 10

    var body: some View {
        VStack(spacing: 15) {
            Image("HeightPage")
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 350)
                .padding(.top, 40)

            Spacer(minLength: 0)

            Text("Height")
                .font(.system(size: 34, weight: .bold, design: .serif))
                .foregroundStyle(Color("MidnightPurple"))

            Text("\(getHeight()) cm")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .fontWeight(.heavy)
                .foregroundColor(.gray)

            let pickerCount = 13

            CustomSlider(pickerCount: pickerCount, offset: $offset, content: {
                HStack(spacing: 0) {
                    ForEach(1 ... pickerCount, id: \.self) { index in
                        VStack {
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: 1, height: 30)
                            Text("\(110 + (index * step))")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                        .frame(width: 20)

                        ForEach(1 ... 4, id: \.self) { _ in
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: 1, height: 15)
                                .frame(width: 20)
                        }
                    }
                    VStack {
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 1, height: 30)
                        Text("\(90 + (pickerCount * 10))")
                            .font(.system(size: 8))
                            .foregroundColor(.gray)
                    }
                    .frame(width: 25)
                }

            })

            .frame(height: 50)
            .overlay(
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 1, height: 50)
                    .offset(x: -1.5, y: -30)
            )
            .padding()

            Button(action: {
                onNext()
            }, label: {
                Text("Continue")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 70)
                    .background(Color("MidnightPurple"))
                    .clipShape(Capsule())
                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                    .shadow(color: Color.purple.opacity(0.2), radius: 10, x: 0, y: 2)
            })
            .padding(.top, 20)
            .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color("MidnightPurple"))
                .scaleEffect(1)
                .offset(y: -getRect().height / 2.4)
        )
    }

    func getHeight() -> String {
        let startHeight = 120
        let progress = offset / 20
        return "\(startHeight + (Int(progress) * 2))"
    }
}

struct HeightPickerView_Previews: PreviewProvider {
    static var previews: some View {
        HeightPickerView(onNext: {})
    }
}
