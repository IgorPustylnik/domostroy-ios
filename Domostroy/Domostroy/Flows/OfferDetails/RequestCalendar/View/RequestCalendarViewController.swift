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
        static let insets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let infoLabelPadding: UIEdgeInsets = .init(top: 8, left: 0, bottom: 8, right: 0)
    }

    // MARK: - UI Elements

    private var calendarView: CalendarView?

    private lazy var bottomLineView = {
        $0.backgroundColor = .separator
        return $0
    }(UIView())

    private lazy var bottomView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))

    private lazy var infoLabel = {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textAlignment = .center
        return $0
    }(UILabel())

    private lazy var applyButton = {
        $0.title = L10n.Localizable.RequestCalendar.Button.apply
        $0.setAction { [weak self] in
            self?.output?.apply()
        }
        return $0
    }(DButton())

    // MARK: - Properties

    var output: RequestCalendarViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
        title = L10n.Localizable.RequestCalendar.title
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        guard let calendarView else {
            return
        }
        view.addSubview(calendarView)
        view.addSubview(bottomLineView)
        view.addSubview(bottomView)
        bottomView.contentView.addSubview(infoLabel)
        bottomView.contentView.addSubview(applyButton)

        calendarView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }

        bottomLineView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
            make.height.equalTo(1 / (view.window?.windowScene?.screen.scale ?? 2))
        }
        bottomView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        infoLabel.snp.makeConstraints { make in
            make.bottom.equalTo(applyButton.snp.top).offset(-Constants.infoLabelPadding.bottom)
            make.top.equalToSuperview().inset(Constants.infoLabelPadding)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(Constants.insets)
        }
        applyButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.insets)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(Constants.insets)
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
        infoLabel.text = config.info
        guard let calendarView else {
            calendarView = CalendarView(initialContent: makeContent(config: config))

            calendarView?.daySelectionHandler = { [weak self] day in
                self?.output?.handleDaySelection(day)
            }

            calendarView?.multiDaySelectionDragHandler = { [weak self] day, state in
                self?.output?.handleDragDaySelection(day, state)
            }

            setupUI()
            setupCloseButton()

            guard let components = config.selectedDayRange?.lowerBound.components,
                  let startDate = config.calendar.date(from: components) else {
                return
            }
            calendarView?.scroll(toDayContaining: startDate, scrollPosition: .centered, animated: false)
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
