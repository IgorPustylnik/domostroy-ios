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
import Combine
import NodeKit

final class RequestCalendarPresenter: RequestCalendarModuleOutput {

    // MARK: - RequestCalendarModuleOutput

    var onDismiss: EmptyClosure?
    var onApply: ((DayComponentsRange?) -> Void)?

    // MARK: - Properties

    weak var view: RequestCalendarViewInput?

    private let offerService: OfferService? = ServiceLocator.shared.resolve()
    private var cancellables: Set<AnyCancellable> = .init()

    private var offerId: Int?
    private var offerCalendarEntity: OfferCalendarEntity?
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
        offerId = viewModel.offerId
        pricePerDay = viewModel.price
        selectedDayRange = viewModel.selectedDates
    }
}

// MARK: - RequestCalendarViewOutput

extension RequestCalendarPresenter: RequestCalendarViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
        view?.setLoading(true)
        loadCalendar()
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

// MARK: - Private methods

private extension RequestCalendarPresenter {

    func configureCalendar() {
        guard let offerCalendarEntity else {
            return
        }
        view?.setupCalendar(config: makeCalendarViewConfig(offerCalendarEntity: offerCalendarEntity))
    }

    func loadCalendar() {
        fetchCalendar { [weak self] in
            self?.view?.setLoading(false)
        } handleResult: { [weak self] result in
            switch result {
            case .success(let calendar):
                guard let self else {
                    return
                }
                self.offerCalendarEntity = calendar
                self.configureCalendar()
            case .failure(let error):
                DropsPresenter.shared.showError(error: error)
            }
        }
    }

    func makeCalendarViewConfig(offerCalendarEntity: OfferCalendarEntity) -> RequestCalendarViewConfig {
        let availableDates = offerCalendarEntity.dates
            .filter { !$0.isBooked }
            .map { $0.date }
            .sorted()
        let firstDate = Date.now
        let lastDate = calendar.date(
            bySetting: .day,
            value: calendar.range(of: .day, in: .month, for: availableDates.last ?? firstDate)?.last ?? 1,
            of: availableDates.last ?? firstDate
        ) ?? firstDate
        let allDates = firstDate...lastDate

        var allDatesInRange: [Date] = []
        var currentDate = calendar.startOfDay(for: firstDate)
        while currentDate <= lastDate {
            allDatesInRange.append(currentDate)
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDate
        }
        self.forbiddenDates = allDatesInRange.filter { !availableDates.contains($0) }
        return .init(
            calendar: .current,
            selectedDayRange: selectedDayRange,
            dates: allDates,
            dayDateFormatter: dayDateFormatter,
            forbiddenDates: forbiddenDates,
            overlaidItemLocations: Set(forbiddenDates.map {
                OverlaidItemLocation.day(containingDate: $0)
            }),
            info: {
                if let pricePerDay, pricePerDay.value != -1,
                   let cost = CalendarHelper.calculateCost(for: selectedDayRange, pricePerDay: pricePerDay) {
                    return L10n.Localizable.RequestCalendar.totalCost(
                        "\(cost.value.stringDroppingTrailingZero)\(cost.currency.description)"
                    )
                } else {
                    return nil
                }
            }()
        )
    }

    func fetchCalendar(completion: EmptyClosure?, handleResult: ((NodeResult<OfferCalendarEntity>) -> Void)?) {
        guard let offerId else {
            completion?()
            return
        }
        offerService?.getOfferCalendar(
            offerId: offerId
        )
        .sink(
            receiveCompletion: { _ in completion?() },
            receiveValue: { handleResult?($0) }
        )
        .store(in: &cancellables)
    }
}
