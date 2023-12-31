//
//  StreaksView.swift
//  SwiftAcceleratorProject
//
//  Created by jeffrey on 28/11/23.
//

import SwiftUI

struct StreaksView: View {
    @Binding var streak: Int
    @State var DaysOfTheWeek: [String] = [
        "Sun",
        "Mon",
        "Tue",
        "Wed",
        "Thu",
        "Fri",
        "Sat",
    ]

    var body: some View {
        VStack {
            Image("\(streak)")
                .resizable()
                .scaledToFit()
                .padding([.leading, .trailing], 16)
                .onAppear {
                    updateImage()
                }

            HStack(spacing: 10) {
                ForEach(DaysOfTheWeek, id: \.self) { x in
                    VStack {
                        Image(systemName: isDayInStreak(day: x) ? "flame.fill" : "flame")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 24)
                            .foregroundColor(isDayInStreak(day: x) ? .orange : .gray)

                        Text(x)
                            .font(.system(size: 10, weight: .black))
                    }
                    .padding(11)
                }
            }
        }
        .frame(width: 400)
        .listRowBackground(Color.red.opacity(0.0))
    }

    private func updateImage() {
        let lastOpenedDate = UserDefaults.standard.object(forKey: "lastOpenedDate") as? Date
        let currentDate = Date.now

        if let lastOpenedDate = lastOpenedDate, Calendar.current.isDate(currentDate, equalTo: lastOpenedDate, toGranularity: .day) {
            return
        }

        if let lastOpenedDate = lastOpenedDate, Calendar.current.isDate(currentDate.addingTimeInterval(-86400), equalTo: lastOpenedDate, toGranularity: .day) {
            streak += 1
        } else {
            streak = 1
        }

        if streak > 7 {
            streak = 1
        }

        UserDefaults.standard.set(streak, forKey: "streak")
        UserDefaults.standard.set(currentDate, forKey: "lastOpenedDate")
    }

    private func isDayInStreak(day: String) -> Bool {
        let currentDay = currentDay()
        let currentDayIndex = DaysOfTheWeek.firstIndex(of: currentDay) ?? 0
        let dayIndex = DaysOfTheWeek.firstIndex(of: day) ?? 0

        let daysSinceLastLogin = (currentDayIndex - dayIndex + 7) % 7

        return daysSinceLastLogin < min(streak, 7)
    }

    private func currentDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: Date.now)
    }
}

struct StreaksView_Previews: PreviewProvider {
    static var previews: some View {
        StreaksView(streak: .constant(3))
    }
}
