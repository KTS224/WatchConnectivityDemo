//
//  CalendarView.swift
//  watchConDemo
//
//  Created by 김태성 on 5/20/24.
//

import SwiftUI

struct CalendarView: View {
    @State private var currentDate = Date()
    private var calendar = Calendar.current
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }
    
    private let koreanWeekdaySymbols = ["일", "월", "화", "수", "목", "금", "토"]
    
    var body: some View {
        ZStack {
            Color("MainColor").ignoresSafeArea()
            VStack {
                HStack {
                    Text("5월의 공부 패턴이에요")
                        .foregroundStyle(.white)
                        .font(.system(size: 17))
                        .bold()
                    Spacer()
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 1)
                .padding(.top, 20)
                
                HStack {
                    Text("잘하고 있어요!")
                        .foregroundStyle(.white)
                        .font(.system(size: 17))
                        .bold()
                    Spacer()
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 30)
                
                daysOfWeekView
                    .padding(.bottom, 20)
                datesGridView
            }
            .padding()
        }
    }
    
    private var daysOfWeekView: some View {
        HStack {
            ForEach(koreanWeekdaySymbols, id: \.self) { day in
                Text(day).frame(maxWidth: .infinity)
                    .font(.system(size: 10))
                    .foregroundStyle(.gray)
            }
        }
    }
    
    private var datesGridView: some View {
        let days = generateDaysInMonth(for: currentDate)
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
            ForEach(days, id: \.self) { date in
                let day = calendar.component(.day, from: date)
                Text(date == Date.distantPast ? "" : "\(calendar.component(.day, from: date))")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.bottom, 20)
                    .font(.system(size: 10))
                    .foregroundStyle(.white)
                    .background(day == 21 ? .cyan.opacity(0.7) : .clear)
                    .background(day == 20 ? .blue : .clear)
                    .background(day == 19 ? .cyan : .clear)
                    .cornerRadius(10)
//                    .overlay {
//                        Circle().background(.red).opacity(0.2)
//                    }
            }
        }
    }
    
    private func generateDaysInMonth(for date: Date) -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: date),
              let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: monthInterval.start)) else {
            return []
        }
        
        var days: [Date] = []
        for day in 0..<calendar.range(of: .day, in: .month, for: monthStart)!.count {
            if let date = calendar.date(byAdding: .day, value: day, to: monthStart) {
                days.append(date)
            }
        }
        
        // Add padding dates for days before the start of the month
        let weekday = calendar.component(.weekday, from: monthStart) - 1
        for _ in 0..<weekday {
            days.insert(Date.distantPast, at: 0)
        }
        
        return days
    }
    
    private func isSameDay(date1: Date, date2: Date) -> Bool {
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}

#Preview {
    CalendarView()
}
