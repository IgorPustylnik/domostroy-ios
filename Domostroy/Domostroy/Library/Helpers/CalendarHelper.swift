//
//  CalendarHelper.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 20.04.2025.
//

import Foundation
import HorizonCalendar

enum CalendarHelper {
    static func calculateCost(for range: DayComponentsRange?, pricePerDay: PriceEntity?) -> PriceEntity? {
        guard let days = range?.numberOfDays(), let pricePerDay else {
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
