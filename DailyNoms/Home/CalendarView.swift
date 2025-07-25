//
//  CalendarView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 30.06.25.
//

import SwiftUI

struct CalendarView: View {
    @Binding var date: Date

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Button {
                    withAnimation {
                        date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color("Calories"))
                }
                Text(date.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.heavy)
                    .foregroundColor(Color("Calories"))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 15)
                Button {
                    withAnimation {
                        date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color("Calories"))
                }
            }
            .padding(.horizontal, 30)

            ZStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 7), spacing: 12) {
                        ForEach(0 ..< 7, id: \.self) { index in
                            let currentDate = Calendar.current.date(byAdding: .day, value: index - Calendar.current.component(.weekday, from: date) + 1, to: date)!
                            VStack(alignment: .center, spacing: 4) {
                                Text(Calendar.current.shortWeekdaySymbols[(Calendar.current.component(.weekday, from: currentDate) + 5) % 7])
                                    .font(.system(.body, design: .rounded))
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color("Calories").opacity(0.8))
                                    .frame(maxWidth: 40, alignment: .center)
                                Text(String(Calendar.current.component(.day, from: currentDate)))
                                    .font(.system(.body, design: .rounded))
                                    .fontWeight(.bold)
                                    .foregroundColor(currentDate == date ? .white : Color("Calories").opacity(0.7))
                                    .frame(width: 40, height: 40)
                                    .background(currentDate == date ? LinearGradient(colors: [Color("Calories"), Color("Calories").opacity(0.7)], startPoint: .top, endPoint: .bottom) : LinearGradient(colors: [Color.clear, Color.clear], startPoint: .top, endPoint: .bottom))
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white.opacity(0.4), lineWidth: 1))
                                    .scaleEffect(currentDate == date ? 1.1 : 1.0)
                                    .animation(.easeInOut(duration: 0.2), value: date)
                                    .padding(.vertical, 4)
                            }
                            .frame(maxWidth: .infinity)
                            .onTapGesture {
                                withAnimation {
                                    date = currentDate
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 25)
                }
            }
            .padding(.vertical, 12)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground).opacity(0.9))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    CalendarView(date: .constant(Date()))
}
