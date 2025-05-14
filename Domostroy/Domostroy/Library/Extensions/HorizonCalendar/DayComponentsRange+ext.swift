//
//  DayComponentsRange+ext.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 14.05.2025.
//

import Foundation
import HorizonCalendar

extension DayComponentsRange {
    func asDatesArray() -> [Date] {
        var dates: [Date] = []
        guard let startDate = Calendar.current.date(from: lowerBound.components),
              let endDate = Calendar.current.date(from: upperBound.components)
        else {
            return dates
        }
        var currentDate = Calendar.current.startOfDay(for: startDate)
        let finalDate = Calendar.current.startOfDay(for: endDate)
        while currentDate <= finalDate {
            dates.append(currentDate)
            guard let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDate
        }
        return dates
    }

    func numberOfDays() -> Int? {
        guard
            let start = Calendar.current.date(from: lowerBound.components),
            let end = Calendar.current.date(from: upperBound.components)
        else {
            return nil
        }

        let diff = Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0
        return diff + 1
    }
}
