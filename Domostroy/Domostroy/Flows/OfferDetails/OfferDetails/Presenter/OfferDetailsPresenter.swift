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
import NodeKit

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

    private let secureStorage: SecureStorage? = ServiceLocator.shared.resolve()
    private let basicStorage: BasicStorage? = ServiceLocator.shared.resolve()
    private let offerService: OfferService? = ServiceLocator.shared.resolve()
    private let cityService: CityService? = ServiceLocator.shared.resolve()
    private let categoryService: CategoryService? = ServiceLocator.shared.resolve()
    private let userService: UserService? = ServiceLocator.shared.resolve()
    private let adminService: AdminService? = ServiceLocator.shared.resolve()
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
        ).sink(
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
                    view?.setupInitialState()
                    view?.configureOffer(viewModel: self.makeOfferViewModel(offer: offer))
                    view?.setupMoreActions(makeMoreActions(for: offer))
                    view?.configurePictures(with: offer.photos.map { self.makePictureViewModel(url: $0.url) })

                    if secureStorage?.loadToken() != nil {
                        view?.setupFavoriteToggle(
                            initialState: offer.isFavorite,
                            toggleAction: { [weak self] newValue, handler in
                                self?.setFavorite(value: newValue) { success in
                                    handler?(success)
                                }
                            })
                    }
                case .failure(let error):
                    DropsPresenter.shared.showError(error: error)
                    self.onDismiss?()
                }
            }
        ).store(in: &cancellables)
    }

    func setFavorite(value: Bool, completion: ((Bool) -> Void)?) {
        guard let offerId else {
            return
        }
        offerService?.setFavorite(
            id: offerId, value: value
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

    func fetchUser(id: Int, userView: OfferDetailsView.ViewModel.User.View) {
        userService?.getUser(
            id: id
        )
        .sink(receiveValue: { result in
            switch result {
            case .success(let user):
                userView.nameLabel.text = user.name
                userView.infoLabel.text = "\(user.offersAmount) \(L10n.Plurals.offer(user.offersAmount))"
                userView.avatarImageView.loadAvatar(id: user.id, name: user.name, url: nil)
            case .failure(let error):
                DropsPresenter.shared.showError(error: error)
            }
        })
        .store(in: &cancellables)
    }

    func fetchCity(
        completion: EmptyClosure? = nil,
        handleResult: ((NodeResult<CityEntity>) -> Void)? = nil
    ) {
        guard let offer else {
            completion?()
            return
        }
        cityService?.getCity(
            id: offer.cityId
        )
        .sink(
            receiveCompletion: { _ in completion?() },
            receiveValue: { handleResult?($0) }
        )
        .store(in: &cancellables)
    }

    func fetchCategory(
        completion: EmptyClosure? = nil,
        handleResult: ((NodeResult<CategoryEntity>) -> Void)? = nil
    ) {
        guard let offer else {
            completion?()
            return
        }
        categoryService?.getCategory(
            id: offer.categoryId
        )
        .sink(
            receiveCompletion: { _ in completion?() },
            receiveValue: { handleResult?($0) }
        )
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
            loadCity: { [weak self] cityLabel in
                self?.fetchCity(completion: nil, handleResult: { result in
                    switch result {
                    case .success(let city):
                        cityLabel.text = city.name
                    case .failure:
                        break
                    }
                })
            },
            loadInfo: { [weak self] completion in
                self?.fetchCategory(handleResult: { result in
                    switch result {
                    case .success(let category):
                        completion([
                            (L10n.Localizable.OfferDetails.Info.category, category.name.lowercased())
                        ])
                    case .failure:
                        break
                    }
                })
            },
            description: offer.description,
            publishedAt: L10n.Localizable.OfferDetails.publishedAt(offer.createdAt.toDMMYY()),
            user: .init(
                url: try? UserUrlRoute.other(offer.userId).url(),
                loadUser: { [weak self] url, userView in
                    self?.fetchUser(id: offer.userId, userView: userView)
                },
                onOpenProfile: { [weak self] in
                    self?.onOpenUser?(offer.userId)
                }
            ),
            isBanned: offer.isBanned,
            banReason: offer.banReason,
            onRent: { [weak self] in
                self?.onRent?()
            }
        )
    }

    func makePictureViewModel(url: URL) -> ImageCollectionViewCell.ViewModel {
        ImageCollectionViewCell.ViewModel(
            imageUrl: url
        ) { imageView, completion in
            DispatchQueue.main.async {
                imageView.kf.setImage(with: url) { _ in
                    completion()
                }
            }
        }
    }

    func banOffer(id: Int, reason: String?, completion: EmptyClosure?, handleResult: ((NodeResult<Void>) -> Void)?) {
        let loading = LoadingOverlayPresenter.shared.show()
        loading.cancellable.store(in: &cancellables)
        adminService?.banOffer(
            banOfferEntity: .init(offerId: id, banReason: reason)
        ).sink(
            receiveCompletion: { _ in
                LoadingOverlayPresenter.shared.hide(id: loading.id)
                completion?()
            },
            receiveValue: { handleResult?($0) }
        ).store(in: &cancellables)
    }

    func unbanOffer(id: Int, completion: EmptyClosure?, handleResult: ((NodeResult<Void>) -> Void)?) {
        let loading = LoadingOverlayPresenter.shared.show()
        loading.cancellable.store(in: &cancellables)
        adminService?.unbanOffer(
            id: id
        ).sink(
            receiveCompletion: { _ in
                LoadingOverlayPresenter.shared.hide(id: loading.id)
                completion?()
            },
            receiveValue: { handleResult?($0) }
        ).store(in: &cancellables)
    }

    func setOfferBan(id: Int, value: Bool, completion: ((Bool) -> Void)?) {
        if value {
            AlertPresenter.enterText(
                title: L10n.Localizable.AdminPanel.Offers.Ban.title,
                message: nil,
                placeholder: L10n.Localizable.AdminPanel.Offers.Ban.Reason.placeholder,
                onConfirm: { [weak self] reason in
                    self?.banOffer(id: id, reason: reason) {
                    } handleResult: { result in
                        switch result {
                        case .success:
                            completion?(true)
                        case .failure(let error):
                            completion?(false)
                            DropsPresenter.shared.showError(error: error)
                        }
                    }
                }, onCancel: { completion?(false) }
            )
        } else {
            unbanOffer(id: id) {
            } handleResult: { result in
                switch result {
                case .success:
                    completion?(true)
                case .failure(let error):
                    completion?(false)
                    DropsPresenter.shared.showError(error: error)
                }
            }

        }
    }

    func makeMoreActions(for offer: OfferDetailsEntity) -> [UIAction] {
        guard
            let role = basicStorage?.get(for: .myRole),
            role == .admin
        else {
            return []
        }
        var actions: [UIAction] = []
        actions.append(
            .init(
                title: offer.isBanned ?
                    L10n.Localizable.OfferDetails.Admin.MoreActions.unban :
                    L10n.Localizable.OfferDetails.Admin.MoreActions.ban,
                image: UIImage(systemName: "nosign"),
                handler: { [weak self] _ in
                    self?.setOfferBan(id: offer.id, value: !offer.isBanned, completion: { success in
                        if success {
                            self?.fetchOffer()
                        }
                    })
                }
            )
        )
        return actions
    }
}
