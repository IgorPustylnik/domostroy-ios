//
//  LessorCalendarPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 25/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation
import HorizonCalendar
import UIKit

final class LessorCalendarPresenter: LessorCalendarModuleOutput {

    // MARK: - LessorCalendarModuleOutput

    var onApply: ((Set<Date>) -> Void)?
    var onDismiss: EmptyClosure?

    // MARK: - Properties

    weak var view: LessorCalendarViewInput?

    private var dates: ClosedRange<Date>?
    private var forbiddenDates: [Date] = []
    private var price: Double?

    private lazy var calendar = Calendar.current

    private var selectedDayComponents: Set<DayComponents> = .init()
    private var isDragGestureDestructive = false

    private lazy var dayDateFormatter: DateFormatter = {
      $0.calendar = calendar
      $0.locale = calendar.locale
      $0.dateFormat = DateFormatter.dateFormat(
        fromTemplate: "EEEE, MMM d, yyyy",
        options: 0,
        locale: calendar.locale ?? Locale.current)
      return $0
    }(DateFormatter())

}

// MARK: - LessorCalendarModuleInput

extension LessorCalendarPresenter: LessorCalendarModuleInput {
    func configure(with viewModel: LessorCalendarConfig) {
        dates = viewModel.dates
        forbiddenDates = viewModel.forbiddenDates
        viewModel.selectedDays.forEach { date in
            let dayComponents = DayComponents(
                month: .init(
                    era: calendar.component(.era, from: date),
                    year: calendar.component(.year, from: date),
                    month: calendar.component(.month, from: date),
                    isInGregorianCalendar: true
                ),
                day: calendar.component(.day, from: date)
            )
            selectedDayComponents.insert(dayComponents)
        }
    }
}

// MARK: - LessorCalendarViewOutput

extension LessorCalendarPresenter: LessorCalendarViewOutput {

    func viewLoaded() {
        configureCalendar()
    }

    func dismiss() {
        onDismiss?()
    }

    func apply() {
        let dates = Set(selectedDayComponents.compactMap { calendar.date(from: $0.components) })
        onApply?(dates)
        onDismiss?()
    }

    func handleDaySelection(_ day: DayComponents) {
        guard let date = calendar.date(from: day.components) else {
            return
        }
        guard !forbiddenDates.contains(date) else {
            return
        }
        if selectedDayComponents.contains(day) {
            selectedDayComponents.remove(day)
        } else {
            selectedDayComponents.insert(day)
        }
        configureCalendar()
    }

    func handleDragDaySelection(_ day: DayComponents, _ gestureState: UIGestureRecognizer.State) {
        guard
            let date = calendar.date(from: day.components),
            !forbiddenDates.contains(date) else {
            return
        }
        if gestureState == .began && selectedDayComponents.contains(day) {
            isDragGestureDestructive = true
        } else if gestureState == .began {
            isDragGestureDestructive = false
        }
        if isDragGestureDestructive {
            selectedDayComponents.remove(day)
        } else {
            selectedDayComponents.insert(day)
        }

        configureCalendar()
    }

    func fillMonth(_ month: MonthComponents) {
        guard let firstDayOfMonth = calendar.date(from: month.components) else {
            return
        }
        guard let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth) else {
            return
        }
        for day in range.lowerBound..<range.upperBound {
            guard let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) else {
                continue
            }
            if forbiddenDates.contains(date) {
                continue
            }
            if let dateRange = dates, !dateRange.contains(date) {
                continue
            }
            let dayComponent = DayComponents(
                month: month,
                day: day
            )
            selectedDayComponents.insert(dayComponent)

        }

        configureCalendar()
    }

    func isMonthFullySelected(_ month: MonthComponents) -> Bool {
        guard let dates,
              let firstDayOfMonth = calendar.date(from: month.components),
              let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth) else {
            return true
        }

        let daysInMonth = range.count
        var selectableDaysInMonth = 0
        var selectedDaysInCurrentMonth = 0

        for day in 1...daysInMonth {
            let dayComponent = DayComponents(month: month, day: day)
            guard let date = calendar.date(from: dayComponent.components) else {
                continue
            }

            if forbiddenDates.contains(date) || (!dates.contains(date)) {
                continue
            }

            selectableDaysInMonth += 1
            if selectedDayComponents.contains(dayComponent) {
                selectedDaysInCurrentMonth += 1
            }
        }

        return selectableDaysInMonth > 0 && selectedDaysInCurrentMonth == selectableDaysInMonth
    }

}

// MARK: - Calendar

private extension LessorCalendarPresenter {

    func configureCalendar() {
        guard let dates else {
            return
        }
        let config = LessorCalendarViewConfig(
            calendar: calendar,
            dates: dates,
            selectedDays: selectedDayComponents,
            dayDateFormatter: dayDateFormatter,
            forbiddenDates: forbiddenDates,
            overlaidItemLocations: Set(forbiddenDates.map {
                OverlaidItemLocation.day(containingDate: $0)
            })
        )
        view?.setupCalendar(config: config)
    }
}
