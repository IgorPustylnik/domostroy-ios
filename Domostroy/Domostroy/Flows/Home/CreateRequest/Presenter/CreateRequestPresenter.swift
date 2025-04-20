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

    private var offer: Offer?
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
              let endDate = Calendar.current.date(from: endDateComponents)
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
            DispatchQueue.main.async {
                self.view?.configureCalendar(with: "You can open calendar now")
            }
        }
    }

    func fetchOffer(id: Int) {
        Task {
            let offer = await _Temporary_Mock_NetworkService().fetchOffer(id: id)
            self.offer = offer
            DispatchQueue.main.async { [weak self] in
                self?.view?.configure(
                    with: .init(
                        imageUrl: offer.images.first,
                        loadImage: { [weak self] url, imageView in
                            self?.loadImage(url: url, imageView: imageView)
                        },
                        title: offer.name,
                        price: "\(offer.price.stringDroppingTrailingZero)₽/день",
                        calendarId: offer.calendarId,
                        loadCalendar: { [weak self] calendarId in
                            self?.loadCalendar(id: calendarId)
                        },
                        onCalendar: { [weak self] in
                            guard let offerCalendar = self?.offerCalendar else {
                                return
                            }
                            self?.onShowCalendar?(
                                .init(
                                    dates: offerCalendar.startDate...offerCalendar.endDate,
                                    forbiddenDates: offerCalendar.forbiddenDates,
                                    selectedDates: self?.selectedDates,
                                    price: offer.price
                                )
                            )
                        }
                    )
                )
            }
        }
    }
}
