//
//  CalendarHelper.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 20.04.2025.
//

import Foundation
import HorizonCalendar

enum CalendarHelper {
    static func numberOfDays(in range: DayComponentsRange?) -> Int? {
        guard
            let range,
            let start = Calendar.current.date(from: range.lowerBound.components),
            let end = Calendar.current.date(from: range.upperBound.components)
        else {
            return nil
        }

        let diff = Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0
        return diff + 1
    }

    static func calculateCost(for range: DayComponentsRange?, pricePerDay: Price?) -> Price? {
        guard let days = numberOfDays(in: range), let pricePerDay else {
            return nil
        }
        return .init(value: Double(days) * pricePerDay.value, currency: pricePerDay.currency)
    }

    static func makeDateRanges(from dayComponents: Set<DayComponents>, calendar: Calendar) -> Set<ClosedRange<Date>> {
        let sortedDates = dayComponents.compactMap {
            calendar.date(from: $0.components)
        }.sorted()

        guard !sortedDates.isEmpty else {
            return []
        }

        var result: Set<ClosedRange<Date>> = []
        var rangeStart = sortedDates[0]
        var previousDate = rangeStart

        for currentDate in sortedDates.dropFirst() {
            if let nextExpectedDate = calendar.date(byAdding: .day, value: 1, to: previousDate),
               calendar.isDate(currentDate, inSameDayAs: nextExpectedDate) {
                previousDate = currentDate
            } else {
                result.insert(rangeStart...previousDate)
                rangeStart = currentDate
                previousDate = currentDate
            }
        }

        result.insert(rangeStart...previousDate)
        return result
    }
}
