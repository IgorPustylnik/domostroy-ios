//
//  RequestCalendarViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 17/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import HorizonCalendar
import SnapKit
import SwiftUI

final class RequestCalendarViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let interMonthSpacing: CGFloat = 24
        static let verticalDayMargin: CGFloat = 8
        static let horizontalDayMargin: CGFloat = 8
    }

    // MARK: - Properties

    private var calendarView: CalendarView?
    var output: RequestCalendarViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
        setupCloseButton()
        // TODO: Localize
        title = "Dates"
    }

    private func addCalendarView() {
        guard let calendarView else {
            return
        }
        view.addSubview(calendarView)
        calendarView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        calendarView.daySelectionHandler = { [weak self] day in
            self?.output?.handleDaySelection(day)
        }

        calendarView.multiDaySelectionDragHandler = { [weak self] day, state in
            self?.output?.handleDragDaySelection(day, state)
        }
    }

    private func setupCloseButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(close)
        )
    }
}

// MARK: - RequestCalendarViewInput

extension RequestCalendarViewController: RequestCalendarViewInput {
    func setupCalendar(config: RequestCalendarViewConfig) {
        guard let calendarView else {
            calendarView = CalendarView(initialContent: makeContent(config: config))
            addCalendarView()
            return
        }
        calendarView.setContent(makeContent(config: config))
    }
}

// MARK: - Private methods

private extension RequestCalendarViewController {
    func makeContent(config: RequestCalendarViewConfig) -> CalendarViewContent {
        var dateRanges: Set<ClosedRange<Date>> = []
        if let selectedDayRange = config.selectedDayRange,
           let lowerBound = config.calendar.date(from: selectedDayRange.lowerBound.components),
           let upperBound = config.calendar.date(from: selectedDayRange.upperBound.components) {
            dateRanges = [lowerBound...upperBound]
        }

        return CalendarViewContent(
            calendar: config.calendar,
            visibleDateRange: config.dates,
            monthsLayout: .vertical(options: .init(scrollsToFirstMonthOnStatusBarTap: true)))
        .interMonthSpacing(Constants.interMonthSpacing)
        .verticalDayMargin(Constants.verticalDayMargin)
        .horizontalDayMargin(Constants.horizontalDayMargin)
        .dayItemProvider { day in
            self.makeDayItemProvider(config: config, day: day)
        }
        .dayRangeItemProvider(for: dateRanges) { dayRangeLayoutContext in
            self.makeDayRangeItemProvider(config: config, dayRangeLayoutContext: dayRangeLayoutContext)
        }
        .monthHeaderItemProvider { month in
            self.makeMonthHeaderItemProvider(config: config, month: month)
        }
        .dayOfWeekItemProvider { _, weekdayIndex in
            self.makeDayOfWeekItemProvider(config: config, weekdayIndex: weekdayIndex)
        }
    }
}

// MARK: - CalendarView Providers

private extension RequestCalendarViewController {
    func makeDayItemProvider(config: RequestCalendarViewConfig, day: DayComponents) -> AnyCalendarItemModel {
        var invariantViewProperties = DayView.InvariantViewProperties.baseInteractive

        if let selectedDayRange = config.selectedDayRange {
            let start = selectedDayRange.lowerBound
            let end = selectedDayRange.upperBound

            if day == start || day == end {
                invariantViewProperties.backgroundShapeDrawingConfig.fillColor = .Domostroy.primary
                invariantViewProperties.textColor = .white
            } else if start < day && day < end {
                invariantViewProperties.textColor = .white
            }
        }

        let date = config.calendar.date(from: day.components)
        if let date, config.forbiddenDates.contains(date) {
            invariantViewProperties.interaction = .disabled
            invariantViewProperties.textColor = .placeholderText
        }

        return DayView.calendarItemModel(
            invariantViewProperties: invariantViewProperties,
            content: .init(
                dayText: "\(day.day)",
                accessibilityLabel: date.map { config.dayDateFormatter.string(from: $0) },
                accessibilityHint: nil))
    }

    func makeDayRangeItemProvider(
        config: RequestCalendarViewConfig,
        dayRangeLayoutContext: DayRangeLayoutContext
    ) -> AnyCalendarItemModel {
        DayRangeIndicatorView.calendarItemModel(
            invariantViewProperties: .init(indicatorColor: .Domostroy.primary),
            content: .init(
                framesOfDaysToHighlight: dayRangeLayoutContext.daysAndFrames.map { $0.frame }
            )
        )
    }

    func makeMonthHeaderItemProvider(
        config: RequestCalendarViewConfig,
        month: MonthComponents
    ) -> AnyCalendarItemModel {
        let monthName = config.dayDateFormatter.standaloneMonthSymbols[month.month - 1].capitalized
        if month.month == 1 {
            return VStack {
                Text(month.year.description)
                    .font(.system(size: 16, weight: .semibold))
                Text(monthName)
                    .font(.system(size: 16, weight: .semibold))
            }
            .padding(.vertical)
            .accessibilityAddTraits(.isHeader)
            .calendarItemModel
        }
        return VStack {
            Text(monthName)
                .font(.system(size: 16, weight: .semibold))
        }
        .padding(.vertical)
        .accessibilityAddTraits(.isHeader)
        .calendarItemModel
    }

    func makeDayOfWeekItemProvider(config: RequestCalendarViewConfig, weekdayIndex: Int) -> AnyCalendarItemModel {
        let dayOfWeekText = config.dayDateFormatter.shortStandaloneWeekdaySymbols[weekdayIndex]
        return DayOfWeekView.calendarItemModel(
            invariantViewProperties: .base,
            content: .init(dayOfWeekText: dayOfWeekText, accessibilityLabel: dayOfWeekText))
    }
}

// MARK: - Selectors

@objc
private extension RequestCalendarViewController {
    func close() {
        output?.dismiss()
    }
}
