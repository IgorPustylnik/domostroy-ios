//
//  CreateRequestPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 17/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import Kingfisher
import HorizonCalendar

final class CreateRequestPresenter: CreateRequestModuleOutput {

    // MARK: - CreateRequestModuleOutput

    var onShowCalendar: ((RequestCalendarConfig?) -> Void)?

    // MARK: - Properties

    weak var view: CreateRequestViewInput?

    private var offer: OfferDetailsEntity?
    private var offerCalendar: OfferCalendar?
    private var selectedDates: DayComponentsRange?
}

// MARK: - CreateRequestModuleInput

extension CreateRequestPresenter: CreateRequestModuleInput {
    func setOfferId(_ id: Int) {
        fetchOffer(id: id)
    }

    func setSelectedDates(_ dates: DayComponentsRange?) {
        self.selectedDates = dates
        guard let startDateComponents = dates?.lowerBound.components,
              let startDate = Calendar.current.date(from: startDateComponents),
              let endDateComponents = dates?.upperBound.components,
              let endDate = Calendar.current.date(from: endDateComponents),
              let offer
        else {
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(
            fromTemplate: "d MMMM",
            options: 0,
            locale: Locale.current)
        if startDate == endDate {
            view?.configureCalendar(
                with: "\(dateFormatter.string(from: endDate))"
            )
        } else {
            view?.configureCalendar(
                with: "\(dateFormatter.string(from: startDate)) — \(dateFormatter.string(from: endDate))"
            )
        }
        view?.configureTotalCost(with: calculateTotalCostText(pricePerDay: offer.price))
    }
}

// MARK: - CreateRequestViewOutput

extension CreateRequestPresenter: CreateRequestViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
    }

    func submit() {
    }

}

// MARK: - Private methods

private extension CreateRequestPresenter {
    func loadImage(url: URL?, imageView: UIImageView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            imageView.kf.setImage(with: url, placeholder: UIImage.Mock.makita)
        }
    }

    func loadCalendar(id: Int) {
        Task {
            let offerCalendar = await _Temporary_Mock_NetworkService().fetchCalendar(id: id)
            self.offerCalendar = offerCalendar
            DispatchQueue.main.async { [weak self] in
                self?.view?.configureCalendar(with: L10n.Localizable.CreateRequest.Placeholder.calendar)
            }
        }
    }

    func fetchOffer(id: Int) {
        Task {
            let offer = await _Temporary_Mock_NetworkService().fetchOffer(id: id)
            self.offer = offer
            DispatchQueue.main.async { [weak self] in
                self?.updateView(with: offer)
            }
        }
    }

    private func updateView(with offer: OfferDetailsEntity) {
        let viewModel = self.makeViewModel(from: offer)
        view?.configure(with: viewModel)
    }

    private func makeViewModel(from offer: OfferDetailsEntity) -> CreateRequestView.ViewModel {
        .init(
            imageUrl: offer.photos.first,
            loadImage: { [weak self] url, imageView in
                self?.loadImage(url: url, imageView: imageView)
            },
            title: offer.title,
            price: LocalizationHelper.pricePerDay(for: offer.price),
            calendarId: offer.calendarId,
            loadCalendar: { [weak self] id in
                self?.loadCalendar(id: id)
            },
            onCalendar: { [weak self] in
                self?.presentCalendar(for: offer)
            }
        )
    }

    private func calculateTotalCostText(pricePerDay: PriceEntity) -> String? {
        guard
            let selectedDates,
            let days = CalendarHelper.numberOfDays(in: selectedDates),
            let totalCost = CalendarHelper.calculateCost(for: selectedDates, pricePerDay: pricePerDay)
        else { return nil }
        return String(format: "%@%@ × %d %@ = %@%@",
            pricePerDay.value.stringDroppingTrailingZero,
            pricePerDay.currency.description,
            days,
            L10n.Plurals.day(days),
            totalCost.value.stringDroppingTrailingZero,
            pricePerDay.currency.description
        )
    }

    private func presentCalendar(for offer: OfferDetailsEntity) {
        guard let offerCalendar else {
            return
        }
        onShowCalendar?(
            .init(
                dates: offerCalendar.startDate...offerCalendar.endDate,
                forbiddenDates: offerCalendar.forbiddenDates,
                selectedDates: selectedDates,
                price: offer.price
            )
        )
    }
}
