//
//  WeightPickerView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 27.05.25.
//

import AudioUnit
import SwiftUI

struct WeightPickerView: View {
    static var startWeight: Double = 40.0
    @Binding var weight: Double
    @State var offset: CGFloat
    var onNext: () -> Void
    var onBack: () -> Void = {}

    init(weight: Binding<Double>, onNext: @escaping () -> Void, onBack: @escaping () -> Void) {
        _weight = weight
        offset = CGFloat(weight.wrappedValue) - CGFloat(Self.startWeight)
        self.onNext = onNext
        self.onBack = onBack
    }

    var body: some View {
        ZStack {
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
                        ForEach(0 ..< pickerCount, id: \.self) { index in
                            VStack {
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(width: 1, height: 30)
                                Text("\(Int(Self.startWeight + (Double(index) * 10)))")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .frame(width: 30)

                            ForEach(1 ... 4, id: \.self) { _ in
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(width: 1, height: 15)
                                    .frame(width: 30)
                            }
                        }
                        VStack {
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: 1, height: 30)
                            Text("\(Int(Self.startWeight + (Double(pickerCount) * 10)))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(width: 30)
                    }

                })

                .frame(height: 50)
                .overlay(
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 1, height: 50)
                        .offset(x: -4, y: -30)
                )
                .padding(.vertical)

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
            BackButton(action: onBack)
                .padding(.top, 40)
                .padding(.leading, 20)
        }
    }

    func getWeight() -> String {
        let progress = offset / 30
        return (Self.startWeight + progress * 2).formatted()
    }
}

struct WeightPickerView_Previews: PreviewProvider {
    static var previews: some View {
        WeightPickerView(weight: .constant(40), onNext: {}, onBack: {})
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

        let width = CGFloat((pickerCount * 5) * 30) + (getRect().width + 30)
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

            let value = (offset / 30).rounded(.toNearestOrAwayFromZero)

            scrollView.setContentOffset(CGPoint(x: value * 30, y: 0), animated: false)

            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            AudioServicesPlayAlertSound(1157)
        }

        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if !decelerate {
                let offset = scrollView.contentOffset.x

                let value = (offset / 30).rounded(.toNearestOrAwayFromZero)

                scrollView.setContentOffset(CGPoint(x: value * 30, y: 0), animated: false)

                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                AudioServicesPlayAlertSound(1157)
            }
        }
    }
}
