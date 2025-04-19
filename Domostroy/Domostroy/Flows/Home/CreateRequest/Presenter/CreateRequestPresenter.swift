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

    private var offerId: Int?
    private var selectedDates: DayComponentsRange?
    private var calendarConfig: RequestCalendarConfig?
}

// MARK: - CreateRequestModuleInput

extension CreateRequestPresenter: CreateRequestModuleInput {
    func set(offerId: Int) {
        self.offerId = offerId
    }
}

// MARK: - CreateRequestViewOutput

extension CreateRequestPresenter: CreateRequestViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
        fetchOffer()
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
            self.calendarConfig = .init(
                dates: offerCalendar.startDate...offerCalendar.endDate,
                forbiddenDates: offerCalendar.forbiddenDates,
                selectedDates: selectedDates
            )
            DispatchQueue.main.async {
                self.view?.configureCalendar(with: "You can open calendar now")
            }
        }
    }

    func fetchOffer() {
        guard let offerId else {
            return
        }
        Task {
            let offer = await _Temporary_Mock_NetworkService().fetchOffer(id: offerId)
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
                            self?.onShowCalendar?(self?.calendarConfig)
                        }
                    )
                )
            }
        }
    }
}
