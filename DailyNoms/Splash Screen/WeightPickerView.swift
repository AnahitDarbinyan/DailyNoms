//
//  WeightPickerView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 27.05.25.
//

import AudioUnit
import SwiftUI

struct WeightPickerView: View {
    @State var offset: CGFloat = 0
    var onNext: () -> Void

    var body: some View {
        VStack(spacing: 15) {
            Image("WeightPage")
                .resizable()
                .scaledToFit()
                .frame(width: 440, height: 400)
                .padding(.top, 40)

            Spacer(minLength: 0)

            Text("Weight")
                .font(.system(size: 34, weight: .bold, design: .serif))
                .foregroundStyle(Color("MidnightPurple"))

            Text("\(getWeight()) Kg")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .fontWeight(.heavy)
                .foregroundColor(.gray)

            let pickerCount = 9

            CustomSlider(pickerCount: pickerCount, offset: $offset, content: {
                HStack(spacing: 0) {
                    ForEach(1 ... pickerCount, id: \.self) { index in
                        VStack {
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: 1, height: 30)
                            Text("\(30 + (index * 10))")
                                .font(.caption)
                                .foregroundColor(.gray)
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
                        Text("\(30 + (pickerCount * 10))")
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
                    .padding(.horizontal, 60)
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
            Circle()
                .fill(Color("MidnightPurple"))
                .scaleEffect(1.5)
                .offset(y: -getRect().height / 2.4)
        )
    }

    func getWeight() -> String {
        let startWeight = 30
        let progress = offset / 20
        return "\(startWeight + (Int(progress) * 2))"
    }
}

struct WeightPickerView_Previews: PreviewProvider {
    static var previews: some View {
        WeightPickerView(onNext: {})
    }
}

// Screen Size
func getRect() -> CGRect {
    return UIScreen.main.bounds
}

struct CustomSlider<Content: View>: UIViewRepresentable {
    var content: Content
    @Binding var offset: CGFloat
    var pickerCount: Int

    init(pickerCount: Int, offset: Binding<CGFloat>, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        _offset = offset
        self.pickerCount = pickerCount
    }

    func makeCoordinator() -> Coordinator {
        return CustomSlider.Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()

        let swiftUIView = UIHostingController(rootView: content).view!

        let width = CGFloat((pickerCount * 5) * 20) + (getRect().width - 30)

        swiftUIView.frame = CGRect(x: 0, y: 0, width: width, height: 50)

        scrollView.contentSize = swiftUIView.frame.size
        scrollView.addSubview(swiftUIView)
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = context.coordinator
        return scrollView
    }

    func updateUIView(_: UIScrollView, context _: Context) {}

    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: CustomSlider

        init(parent: CustomSlider) {
            self.parent = parent
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.offset = scrollView.contentOffset.x
        }

        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let offset = scrollView.contentOffset.x

            let value = (offset / 20).rounded(.toNearestOrAwayFromZero)

            scrollView.setContentOffset(CGPoint(x: value * 20, y: 0), animated: false)

            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            AudioServicesPlayAlertSound(1157)
        }

        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if !decelerate {
                let offset = scrollView.contentOffset.x

                let value = (offset / 20).rounded(.toNearestOrAwayFromZero)

                scrollView.setContentOffset(CGPoint(x: value * 20, y: 0), animated: false)

                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                AudioServicesPlayAlertSound(1157)
            }
        }
    }
}
