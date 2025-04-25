//
//  LessorCalendarViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 25/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import HorizonCalendar
import SnapKit
import SwiftUI

final class LessorCalendarViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let interMonthSpacing: CGFloat = 24
        static let verticalDayMargin: CGFloat = 8
        static let horizontalDayMargin: CGFloat = 8
        static let insets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
    }

    // MARK: - UI Elements

    private var calendarView: CalendarView?

    private lazy var bottomLineView = {
        $0.backgroundColor = .separator
        return $0
    }(UIView())

    private lazy var bottomView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))

    private lazy var applyButton = {
        // TODO: Localize
        $0.title = "Apply"
        $0.setAction { [weak self] in
            self?.output?.apply()
        }
        return $0
    }(DButton())

    // MARK: - Properties

    var output: LessorCalendarViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
        // TODO: Localize
        title = "Dates"
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        guard let calendarView else {
            return
        }
        view.addSubview(calendarView)
        view.addSubview(bottomLineView)
        view.addSubview(bottomView)
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
        applyButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.insets)
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

// MARK: - LessorCalendarViewInput

extension LessorCalendarViewController: LessorCalendarViewInput {
    func setupCalendar(config: LessorCalendarViewConfig) {
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
            return
        }

        calendarView.setContent(makeContent(config: config))
    }
}

// MARK: - Private methods

private extension LessorCalendarViewController {
    func makeContent(config: LessorCalendarViewConfig) -> CalendarViewContent {
        .init(
            calendar: config.calendar,
            visibleDateRange: config.dates,
            monthsLayout: .vertical(
                options: .init(alwaysShowCompleteBoundaryMonths: false, scrollsToFirstMonthOnStatusBarTap: true)
            )
        )
        .interMonthSpacing(Constants.interMonthSpacing)
        .verticalDayMargin(Constants.verticalDayMargin)
        .horizontalDayMargin(Constants.horizontalDayMargin)

        .dayItemProvider { day in
            self.makeDayItemProvider(config: config, day: day)
        }

        .dayRangeItemProvider(
            for: CalendarHelper.makeDateRanges(
                from: config.selectedDays,
                calendar: config.calendar
            )
        ) { dayRangeLayoutContext in
            self.makeDayRangeItemProvider(config: config, dayRangeLayoutContext: dayRangeLayoutContext)
        }

        .monthHeaderItemProvider { month in
            self.makeMonthHeaderItemProvider(
                config: config,
                month: month,
                isMonthFilled: { [weak self] in
                    return self?.output?.isMonthFullySelected(month) ?? false
                }()) { [weak self] month in
                    self?.output?.fillMonth(month)
            }
        }

        .dayOfWeekItemProvider { _, weekdayIndex in
            self.makeDayOfWeekItemProvider(config: config, weekdayIndex: weekdayIndex)
        }
    }
}

// MARK: - CalendarView Providers

private extension LessorCalendarViewController {
    func makeDayItemProvider(config: LessorCalendarViewConfig, day: DayComponents) -> AnyCalendarItemModel {
        var invariantViewProperties = DayView.InvariantViewProperties.baseInteractive

        let selectedDays = config.selectedDays
        if selectedDays.contains(day) {
            invariantViewProperties.backgroundShapeDrawingConfig.fillColor = .Domostroy.primary
            invariantViewProperties.textColor = .white
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
        config: LessorCalendarViewConfig,
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
        config: LessorCalendarViewConfig,
        month: MonthComponents,
        isMonthFilled: Bool,
        onFillMonthTap: @escaping (MonthComponents) -> Void
    ) -> AnyCalendarItemModel {
        let monthName = config.dayDateFormatter.standaloneMonthSymbols[month.month - 1].capitalized

        let headerView = HStack {
            Spacer()
            VStack(alignment: .center) {
                if month.month == 1 {
                    Text(month.year.description)
                        .font(.system(size: 16, weight: .semibold))
                }
                Text(monthName)
                    .font(.system(size: 16, weight: .semibold))
            }
            if !isMonthFilled {
                Button(action: {
                    onFillMonthTap(month)
                }) {
                    Image(systemName: "plus.circle.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, Color.Domostroy.primary)
                        .font(.system(size: 20))
                }
            }
            Spacer()
        }
        .frame(minHeight: 20)
        .padding(.vertical)
        .accessibilityAddTraits(.isHeader)

        return headerView.calendarItemModel
    }

    func makeDayOfWeekItemProvider(config: LessorCalendarViewConfig, weekdayIndex: Int) -> AnyCalendarItemModel {
        let dayOfWeekText = config.dayDateFormatter.shortStandaloneWeekdaySymbols[weekdayIndex]
        return DayOfWeekView.calendarItemModel(
            invariantViewProperties: .base,
            content: .init(dayOfWeekText: dayOfWeekText, accessibilityLabel: dayOfWeekText))
    }
}

// MARK: - Selectors

@objc
private extension LessorCalendarViewController {
    func close() {
        output?.dismiss()
    }
}
