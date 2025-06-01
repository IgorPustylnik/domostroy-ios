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
import Combine
import NodeKit

final class CreateRequestPresenter: CreateRequestModuleOutput {

    // MARK: - CreateRequestModuleOutput

    var onShowCalendar: ((RequestCalendarConfig?) -> Void)?
    var onCreated: EmptyClosure?

    // MARK: - Properties

    weak var view: CreateRequestViewInput?

    private var offer: OfferDetailsEntity?
    private var selectedDates: DayComponentsRange?

    private let offerService: OfferService? = ServiceLocator.shared.resolve()
    private let rentService: RentService? = ServiceLocator.shared.resolve()
    private var cancellables: Set<AnyCancellable> = .init()
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
        view?.configureTotalCost(with: offer.price.value != -1 ? calculateTotalCostText(pricePerDay: offer.price) : nil)
    }
}

// MARK: - CreateRequestViewOutput

extension CreateRequestPresenter: CreateRequestViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
        view?.configureCalendar(with: L10n.Localizable.CreateRequest.Placeholder.calendar)
    }

    func submit() {
        guard let selectedDates, !selectedDates.isEmpty else {
            presentCalendar()
            return
        }
        let loading = LoadingOverlayPresenter.shared.show()
        loading.cancellable.store(in: &cancellables)
        view?.setSubmissionActivity(isLoading: true)
        createRequest(
            completion: { [weak self] in
                self?.view?.setSubmissionActivity(isLoading: false)
                LoadingOverlayPresenter.shared.hide(id: loading.id)
            },
            handleResult: { [weak self] result in
                switch result {
                case .success:
                    DropsPresenter.shared.showSuccess(subtitle: L10n.Localizable.CreateRequest.Message.created)
                    self?.onCreated?()
                case .failure(let error):
                    DropsPresenter.shared.showError(error: error)
                }
            }
        )
    }

}

// MARK: - Private methods

private extension CreateRequestPresenter {
    func loadImage(url: URL?, imageView: UIImageView) {
        DispatchQueue.main.async {
            imageView.kf.setImage(with: url)
        }
    }

    func fetchOffer(id: Int) {
        offerService?.getOffer(
            id: id
        )
        .sink(receiveValue: { [weak self] result in
            switch result {
            case .success(let offer):
                self?.offer = offer
                self?.updateView(with: offer)
            case .failure(let error):
                DropsPresenter.shared.showError(error: error)
            }
        })
        .store(in: &cancellables)
    }

    func createRequest(completion: EmptyClosure?, handleResult: ((NodeResult<Void>) -> Void)?) {
        guard let offer else {
            completion?()
            return
        }
        rentService?.createRentRequest(
            createRequestEntity: .init(offerId: offer.id, dates: selectedDates?.asDatesArray() ?? [])
        )
        .sink(
            receiveCompletion: { _ in completion?() },
            receiveValue: { handleResult?($0) }
        )
        .store(in: &cancellables)
    }

    func updateView(with offer: OfferDetailsEntity) {
        let viewModel = self.makeViewModel(from: offer)
        view?.configure(with: viewModel)
    }

    func makeViewModel(from offer: OfferDetailsEntity) -> CreateRequestView.ViewModel {
        .init(
            offer: .init(
                imageUrl: offer.photos.first?.url,
                loadImage: { [weak self] url, imageView in
                    self?.loadImage(url: url, imageView: imageView)
                },
                title: offer.title,
                price: LocalizationHelper.pricePerDay(for: offer.price)
            ),
            onCalendar: { [weak self] in
                self?.presentCalendar()
            }
        )
    }

    func calculateTotalCostText(pricePerDay: PriceEntity) -> String? {
        guard
            let selectedDates,
            let days = selectedDates.numberOfDays(),
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

    func presentCalendar() {
        guard let offer else {
            return
        }
        onShowCalendar?(
            .init(
                offerId: offer.id,
                selectedDates: selectedDates,
                price: offer.price
            )
        )
    }
}
