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

final class OfferDetailsPresenter: OfferDetailsModuleOutput {

    // MARK: - OfferDetailsModuleOutput

    var onOpenUser: ((Int) -> Void)?
    var onRent: EmptyClosure?

    // MARK: - Properties

    weak var view: OfferDetailsViewInput?

    private var offerId: Int?

    var picturesAdapter: BaseCollectionManager?

    deinit {
        print("☠️ OfferDetailsPresenter умер")
    }

}

private extension OfferDetailsPresenter {

    func fetchOffer() {
        guard let offerId else {
            return
        }
        view?.setLoading(true)
        Task {
            let offer = await _Temporary_Mock_NetworkService().fetchOffer(id: offerId)

            DispatchQueue.main.async { [weak self] in
                self?.view?.setLoading(false)
                self?.view?.setupFavoriteToggle(
                    initialState: offer.isFavorite,
                    toggleAction: { [weak self] newValue, handler in
                        self?.setFavorite(value: newValue) { success in
                            handler?(success)
                        }
                    }
                )
                self?.view?.setupInitialState()
                self?.view?.configureOffer(
                    viewModel: .init(
                        // TODO: Localize
                        price: "\(offer.price.stringDroppingTrailingZero)₽/день",
                        title: offer.name,
                        // TODO: Localize
                        city: "г. \(offer.city.name)",
                        specs: [
                            ("Состояние", "новое"),
                            ("Производитель", "Makita")
                        ],
                        description: offer.description,
                        user: .init(
                            url: _Temporary_EndpointConstructor.user(id: offer.userId).url,
                            loadUser: { [weak self] url, userView in
                                self?.fetchUser(url: url, userView: userView)
                            },
                            onOpenProfile: { [weak self] in
                                self?.openUser(id: offer.userId)
                            }
                        ),
                        onRent: { [weak self] in
                            self?.rent()
                        }
                    )
                )
                self?.fillPictures(for: offer)
            }
        }
    }

    func setFavorite(value: Bool, completion: ((Bool) -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            completion?(false)
        }
    }

    func fetchUser(url: URL?, userView: OfferDetailsView.UserView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            userView.name.text = "Test user"
            userView.offerAmount.text = "4 оффера"
            userView.avatar.kf.setImage(with: url, placeholder: UIImage.Mock.makita)
        }
    }

    func openUser(id: Int) {
        onOpenUser?(id)
    }

    func fillPictures(for offer: Offer) {
        var generators: [CollectionCellGenerator] = []
        offer.images.forEach {
            generators.append(makeGenerator(from: $0))
        }
        picturesAdapter?.clearCellGenerators()
        picturesAdapter?.addCellGenerators(generators)
        picturesAdapter?.forceRefill()
    }

    func makeGenerator(from imageUrl: URL) -> CollectionCellGenerator {
        let viewModel = ImageCollectionViewCell.ViewModel(
            imageUrl: imageUrl) { [weak self] url, imageView in
                self?.loadImage(url: url, imageView: imageView)
        }

        let generator = ImageCollectionViewCell.rddm.baseGenerator(with: viewModel, and: .class)
        generator.didSelectEvent += { [weak self] in
            print("did select \(imageUrl)")
        }
        return generator
    }

    private func loadImage(url: URL?, imageView: UIImageView) {
        DispatchQueue.main.async {
            imageView.kf.setImage(with: URL(string: ""), placeholder: UIImage.Mock.makita)
        }
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
