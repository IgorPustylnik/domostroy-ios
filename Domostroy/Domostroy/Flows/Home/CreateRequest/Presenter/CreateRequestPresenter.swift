//
//  CreateRequestPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 17/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import Kingfisher

final class CreateRequestPresenter: CreateRequestModuleOutput {

    // MARK: - CreateRequestModuleOutput

    // MARK: - Properties

    weak var view: CreateRequestViewInput?

    private var offerId: Int?
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
        view?.configure(
            with: .init(
                imageUrl: nil,
                loadImage: { [weak self] url, imageView in
                    self?.loadImage(url: url, imageView: imageView)
                },
                title: "Шуруповёрт Makita",
                price: "500₽/день",
                onCalendar: { [weak self] in
                    self?.openCalendar()
                }
            )
        )
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
                        onCalendar: { [weak self] in
                            self?.openCalendar()
                        }
                    )
                )
            }
        }
    }

    func openCalendar() {

    }
}
