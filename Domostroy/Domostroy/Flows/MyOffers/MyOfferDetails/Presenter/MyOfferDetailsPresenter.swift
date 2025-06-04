//
//  MyOfferDetailsPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 15/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager
import Kingfisher
import Combine
import NodeKit

final class MyOfferDetailsPresenter: MyOfferDetailsModuleOutput {

    // MARK: - OfferDetailsModuleOutput

    var onOpenFullScreenImages: (([URL], Int) -> Void)?
    var onEdit: ((Int) -> Void)?
    var onDeleted: EmptyClosure?
    var onCalendar: ((Int) -> Void)?
    var onDismiss: EmptyClosure?

    // MARK: - Properties

    weak var view: MyOfferDetailsViewInput?

    private var offerId: Int?
    private var offer: OfferDetailsEntity?

    private let secureStorage: SecureStorage? = ServiceLocator.shared.resolve()
    private let offerService: OfferService? = ServiceLocator.shared.resolve()
    private let cityService: CityService? = ServiceLocator.shared.resolve()
    private let categoryService: CategoryService? = ServiceLocator.shared.resolve()
    private let userService: UserService? = ServiceLocator.shared.resolve()
    private var cancellables: Set<AnyCancellable> = .init()

}

// MARK: - MyOfferDetailsModuleInput

extension MyOfferDetailsPresenter: MyOfferDetailsModuleInput {

    func set(offerId: Int) {
        self.offerId = offerId
    }

    func reload() {
        loadOffer()
    }

    func setImage(index: Int) {
        view?.scrollToImage(at: index)
    }

}

// MARK: - MyOfferDetailsViewOutput

extension MyOfferDetailsPresenter: MyOfferDetailsViewOutput {

    func viewLoaded() {
        loadOffer()
    }

    func showCalendar() {
        guard let offerId else {
            return
        }
        onCalendar?(offerId)
    }

    func openFullScreenImages(initialIndex: Int) {
        guard let offer else {
            return
        }
        onOpenFullScreenImages?(offer.photos.map { $0.url }, initialIndex)
    }

}

// MARK: - Network requests

private extension MyOfferDetailsPresenter {

    func loadOffer() {
        view?.setLoading(true)
        fetchOffer { [ weak self] in
            self?.view?.setLoading(false)
        } handleResult: { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(let offer):
                AnalyticsEvent.offerViewed(offerId: offer.id.description, source: "MyOfferDetails").send()
                self.offer = offer
                self.view?.setupInitialState()
                self.view?.configureOffer(viewModel: self.makeOfferViewModel(offer: offer))
                self.view?.configurePictures(with: offer.photos.map { self.makePictureViewModel(url: $0.url) })
                self.view?.setupMoreActions(self.makeMoreActions())
            case .failure(let error):
                DropsPresenter.shared.showError(error: error)
                self.onDismiss?()
            }
        }
    }

    func fetchOffer(completion: EmptyClosure? = nil, handleResult: ((NodeResult<OfferDetailsEntity>) -> Void)? = nil) {
        guard let offerId else {
            return
        }
        offerService?.getOffer(
            id: offerId
        )
        .sink(
            receiveCompletion: { _ in completion?() },
            receiveValue: { handleResult?($0) }
        )
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

    func deleteOffer() {
        guard let offerId else {
            return
        }
        offerService?.deleteOffer(
            id: offerId
        ).sink { [weak self] result in
            switch result {
            case .success:
                self?.onDeleted?()
            case .failure(let error):
                DropsPresenter.shared.showError(error: error)
            }
        }.store(in: &cancellables)
    }
}

// MARK: - ViewModels

private extension MyOfferDetailsPresenter {

    func makeOfferViewModel(offer: OfferDetailsEntity) -> MyOfferDetailsView.ViewModel {
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
            onCalendar: { [weak self] in
                self?.showCalendar()
            },
            isBanned: offer.isBanned,
            banReason: {
                if offer.isBanned {
                    if let banReason = offer.banReason {
                        return L10n.Localizable.OfferDetails.bannedFor(banReason)
                    } else {
                        return L10n.Localizable.OfferDetails.banned
                    }
                }
                return nil
            }()
        )
    }

    func makeMoreActions() -> [UIAction] {
        var actions: [UIAction] = []
        guard let offerId else {
            return actions
        }
        actions.append(
            .init(
                title: L10n.Localizable.OfferDetails.My.MoreActions.edit,
                image: UIImage(systemName: "pencil"),
                handler: { [weak self] _ in
                    self?.onEdit?(offerId)
                }
            )
        )
        actions.append(
            .init(
                title: L10n.Localizable.OfferDetails.My.MoreActions.delete,
                image: UIImage(systemName: "trash"),
                attributes: .destructive,
                handler: { [weak self] _ in
                    self?.deleteOffer()
                }
            )
        )
        return actions
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
}
