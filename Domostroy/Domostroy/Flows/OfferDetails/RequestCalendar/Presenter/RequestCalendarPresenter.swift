//
//  RequestCalendarPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 17/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation
import HorizonCalendar
import UIKit

final class RequestCalendarPresenter: RequestCalendarModuleOutput {

    // MARK: - RequestCalendarModuleOutput

    var onDismiss: EmptyClosure?
    var onApply: ((DayComponentsRange?) -> Void)?

    // MARK: - Properties

    weak var view: RequestCalendarViewInput?

    private var dates: ClosedRange<Date>?
    private var forbiddenDates: [Date] = []
    private var pricePerDay: PriceEntity?

    private lazy var calendar = Calendar.current
    private var selectedDayRange: DayComponentsRange?
    private var selectedDayRangeAtStartOfDrag: DayComponentsRange?

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

// MARK: - RequestCalendarModuleInput

extension RequestCalendarPresenter: RequestCalendarModuleInput {
    func configure(with viewModel: RequestCalendarConfig) {
        dates = viewModel.dates
        pricePerDay = viewModel.price
        forbiddenDates = viewModel.forbiddenDates
        selectedDayRange = viewModel.selectedDates
    }
}

// MARK: - RequestCalendarViewOutput

extension RequestCalendarPresenter: RequestCalendarViewOutput {

    func viewLoaded() {
        configureCalendar()
    }

    func dismiss() {
        onDismiss?()
    }

    func apply() {
        onApply?(selectedDayRange)
        onDismiss?()
    }

    func handleDaySelection(_ day: DayComponents) {
        guard let date = calendar.date(from: day.components) else {
            return
        }
        if forbiddenDates.contains(date) {
            selectedDayRange = day...day
            configureCalendar()
            return
        }

        var tentativeRange = selectedDayRange
        DayRangeSelectionHelper.updateDayRange(
            afterTapSelectionOf: day,
            existingDayRange: &tentativeRange
        )

        if let range = tentativeRange,
           let startDate = calendar.date(from: range.lowerBound.components),
           let endDate = calendar.date(from: range.upperBound.components),
           forbiddenDates.contains(where: { (startDate...endDate).contains($0) }) {
            selectedDayRange = day...day
            configureCalendar()
            return
        }

        selectedDayRange = tentativeRange
        configureCalendar()
    }

    func handleDragDaySelection(_ day: DayComponents, _ gestureState: UIGestureRecognizer.State) {
        var tentativeRange = selectedDayRange
        DayRangeSelectionHelper.updateDayRange(
            afterDragSelectionOf: day,
            existingDayRange: &tentativeRange,
            initialDayRange: &selectedDayRangeAtStartOfDrag,
            state: gestureState,
            calendar: calendar
        )

        if let range = tentativeRange,
           let startDate = calendar.date(from: range.lowerBound.components),
           let endDate = calendar.date(from: range.upperBound.components),
           forbiddenDates.contains(where: { (startDate...endDate).contains($0) }) {
            return
        }

        selectedDayRange = tentativeRange
        configureCalendar()
    }

}

// MARK: - Calendar

private extension RequestCalendarPresenter {

    func configureCalendar() {
        guard let dates else {
            return
        }
        let config = RequestCalendarViewConfig(
            calendar: calendar,
            selectedDayRange: selectedDayRange,
            dates: dates,
            dayDateFormatter: dayDateFormatter,
            forbiddenDates: forbiddenDates,
            overlaidItemLocations: Set(forbiddenDates.map {
                OverlaidItemLocation.day(containingDate: $0)
            }),
            info: {
                if let cost = CalendarHelper.calculateCost(for: selectedDayRange, pricePerDay: pricePerDay) {
                    return L10n.Localizable.RequestCalendar.totalCost("\(cost.value.stringDroppingTrailingZero)\(cost.currency.description)")
                } else {
                    return nil
                }
            }()
        )
        view?.setupCalendar(config: config)
    }
}
