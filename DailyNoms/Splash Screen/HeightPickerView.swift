//
//  HeightPickerView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 05.06.25.
//

import AudioUnit
import SwiftUI

struct HeightPickerView: View {
    static var startHeight: Double = 130.0
    @Binding var height: Double
    @State var offset: CGFloat
    var onNext: () -> Void
    var onBack: () -> Void = {}
    let endHeight = 250
    let step = 10

    init(onNext: @escaping () -> Void, height: Binding<Double>, onBack: @escaping () -> Void) {
        let progress = (height.wrappedValue - Self.startHeight) / 2.0
        offset = CGFloat(progress * 20.0)
        self.onNext = onNext
        _height = height
        self.onBack = onBack
    }

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

            CustomSliderHeight(pickerCount: pickerCount, offset: $offset) {
                tickMarks(pickerCount: pickerCount)
            }
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
        BackButton(action: onBack)
            .padding(.top, 40)
            .padding(.leading, 20)
    }

    func getHeight() -> String {
        let startHeight = 130
        let progress = offset / 20
        return "\(startHeight + (Int(progress) * 2))"
    }

    @ViewBuilder
    func majorTick(at index: Int) -> some View {
        VStack {
            Rectangle()
                .fill(Color.gray)
                .frame(width: 1, height: 30)
            Text("\(Int(Self.startHeight + Double(index * step)))")
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .frame(width: 20)
    }

    @ViewBuilder
    func minorTick() -> some View {
        Rectangle()
            .fill(Color.gray)
            .frame(width: 1, height: 15)
            .frame(width: 20)
    }

    @ViewBuilder
    func endTick(pickerCount: Int) -> some View {
        VStack {
            Rectangle()
                .fill(Color.gray)
                .frame(width: 1, height: 30)
            Text("\(100 + (pickerCount * 10))")
                .font(.system(size: 8))
                .foregroundColor(.gray)
        }
        .frame(width: 25)
    }

    @ViewBuilder
    func tickMarks(pickerCount: Int) -> some View {
        HStack(spacing: 0) {
            ForEach(0 ..< pickerCount, id: \.self) { index in
                majorTick(at: index)
                ForEach(1 ... 4, id: \.self) { _ in
                    minorTick()
                }
            }
            endTick(pickerCount: pickerCount)
        }
    }
}

struct HeightPickerView_Previews: PreviewProvider {
    static var previews: some View {
        HeightPickerView(onNext: {}, height: .constant(130), onBack: {})
    }
}

struct CustomSliderHeight<Content: View>: UIViewRepresentable {
    var content: Content
    @Binding var offset: CGFloat
    var pickerCount: Int

    init(pickerCount: Int, offset: Binding<CGFloat>, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        _offset = offset
        self.pickerCount = pickerCount
    }

    func makeCoordinator() -> Coordinator {
        return CustomSliderHeight.Coordinator(parent: self)
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

        let initialOffset = (width - getRect().width) / 2
        scrollView.contentOffset.x = initialOffset + CGFloat(offset)

        return scrollView
    }

    func updateUIView(_: UIScrollView, context _: Context) {}

    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: CustomSliderHeight

        init(parent: CustomSliderHeight) {
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
