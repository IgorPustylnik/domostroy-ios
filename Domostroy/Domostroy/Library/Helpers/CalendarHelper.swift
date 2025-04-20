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

    static func calculateCost(for range: DayComponentsRange?, price: Double?) -> Double? {
        guard let days = numberOfDays(in: range), let price else {
            return nil
        }
        return Double(days) * price
    }
}
