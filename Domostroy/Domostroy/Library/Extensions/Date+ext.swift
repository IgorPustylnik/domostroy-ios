//
//  Date+ext.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 25.04.2025.
//

import Foundation

extension Date {
    func monthAndYearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"

        return formatter.string(from: self)
    }

    func toDMMYY() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d.MM.yy"
        return formatter.string(from: self)
    }
}

extension Collection where Element == Date {
    func formattedDateRanges() -> String {
        guard !self.isEmpty else {
            return ""
        }

        let calendar = Calendar.current
        let sortedDates = self.sorted()

        var result: [String] = []
        var rangeStart = sortedDates[0]
        var previousDate = rangeStart

        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "d MMMM"

        func appendRange(from start: Date, to end: Date) {
            if calendar.isDate(start, inSameDayAs: end) {
                result.append(dateFormatter.string(from: start))
            } else {
                let startDay = calendar.component(.day, from: start)
                let endDay = calendar.component(.day, from: end)
                let startMonth = calendar.component(.month, from: start)
                let endMonth = calendar.component(.month, from: end)

                if startMonth == endMonth {
                    let dayRange = "\(startDay) – \(endDay) \(dateFormatter.monthSymbols[startMonth - 1])"
                    result.append(dayRange)
                } else {
                    let range = "\(dateFormatter.string(from: start)) – \(dateFormatter.string(from: end))"
                    result.append(range)
                }
            }
        }

        for date in sortedDates.dropFirst() {
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: previousDate),
               calendar.isDate(date, inSameDayAs: nextDate) {
                previousDate = date
            } else {
                appendRange(from: rangeStart, to: previousDate)
                rangeStart = date
                previousDate = date
            }
        }

        appendRange(from: rangeStart, to: previousDate)
        return result.joined(separator: ", ")
    }
}
