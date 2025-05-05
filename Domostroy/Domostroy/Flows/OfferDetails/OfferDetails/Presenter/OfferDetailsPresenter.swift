//
//  OfferDetailsPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 10/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation
import UIKit
import ReactiveDataDisplayManager
import Kingfisher
import Combine

final class OfferDetailsPresenter: OfferDetailsModuleOutput {

    // MARK: - OfferDetailsModuleOutput

    var onOpenUser: ((Int) -> Void)?
    var onRent: EmptyClosure?
    var onDeinit: EmptyClosure?
    var onDismiss: EmptyClosure?

    // MARK: - Properties

    weak var view: OfferDetailsViewInput?

    private var offerId: Int?
    private var offer: OfferDetailsEntity?

    private var offerService: OfferService? = ServiceLocator.shared.resolve()
    private var userService: UserService? = ServiceLocator.shared.resolve()
    private var cancellables: Set<AnyCancellable> = .init()

    deinit {
        onDeinit?()
    }

}

// MARK: - OfferDetailsModuleInput

extension OfferDetailsPresenter: OfferDetailsModuleInput {

    func set(offerId: Int) {
        self.offerId = offerId
    }

}

// MARK: - OfferDetailsViewOutput

extension OfferDetailsPresenter: OfferDetailsViewOutput {

    func viewLoaded() {
        fetchOffer()
    }

    func rent() {
        onRent?()
    }

}

// MARK: - Network requests

private extension OfferDetailsPresenter {

    func fetchOffer() {
        guard let offerId else {
            return
        }
        view?.setLoading(true)
        offerService?.getOffer(
            id: offerId
        )
        .sink(
            receiveCompletion: { [weak self] _ in
                self?.view?.setLoading(false)
            },
            receiveValue: { [weak self] result in
                guard let self else {
                    return
                }
                switch result {
                case .success(let offer):
                    self.offer = offer
                    self.view?.setupInitialState()
                    self.view?.configureOffer(viewModel: self.makeOfferViewModel(offer: offer))
                    self.view?.configurePictures(with: offer.photos.map { self.makePictureViewModel(url: $0) })
                    self.view?.setupFavoriteToggle(initialState: offer.isFavorite, toggleAction: { newValue, handler in
                        self.setFavorite(value: newValue) { success in
                            handler?(success)
                        }
                    })
                case .failure(let error):
                    DropsPresenter.shared.showError(error: error)
                    self.onDismiss?()
                }
            }
        )
        .store(in: &cancellables)
    }

    func setFavorite(value: Bool, completion: ((Bool) -> Void)?) {
        guard let offerId else {
            return
        }
        offerService?.toggleFavorite(
            id: offerId
        )
        .sink(
            receiveValue: { result in
                switch result {
                case .success:
                    completion?(true)
                case .failure(let error):
                    completion?(false)
                    DropsPresenter.shared.showError(error: error)
                }
            }
        )
        .store(in: &cancellables)
    }

    func fetchUser(id: Int, userView: OfferDetailsView.UserView) {
        userService?.getUser(
            id: id
        )
        .sink(receiveValue: { result in
            switch result {
            case .success(let user):
                userView.name.text = user.name
                userView.infoLabel.text = "\(user.offersAmount) \(L10n.Plurals.offer(user.offersAmount))"
                userView.avatar.image = .initialsAvatar(name: user.name, hashable: user.id)
            case .failure(let error):
                DropsPresenter.shared.showError(error: error)
            }
        })
        .store(in: &cancellables)
    }

    func openUser(id: Int) {
        onOpenUser?(id)
    }
}

private extension OfferDetailsPresenter {

    func makeOfferViewModel(offer: OfferDetailsEntity) -> OfferDetailsView.ViewModel {
        .init(
            price: LocalizationHelper.pricePerDay(for: offer.price),
            title: offer.title,
            // TODO: Receive city name
            city: "Воронеж"/*offer.cityId.description*/,
            specs: [(L10n.Localizable.OfferDetails.Specifications.category, offer.category.name)],
            description: offer.description,
            user: .init(
                url: try? UserUrlRoute.other(offer.userId).url(),
                loadUser: { [weak self] url, userView in
                    self?.fetchUser(id: offer.userId, userView: userView)
                },
                onOpenProfile: { [weak self] in
                    self?.onOpenUser?(offer.userId)
                }
            ),
            onRent: { [weak self] in
                self?.onRent?()
            }
        )
    }

    func makePictureViewModel(url: URL) -> ImageCollectionViewCell.ViewModel {
        ImageCollectionViewCell.ViewModel(
            imageUrl: url
        ) { url, imageView, completion in
            DispatchQueue.main.async {
                imageView.kf.setImage(with: url) { _ in
                    completion()
                }
            }
        }
    }
}
