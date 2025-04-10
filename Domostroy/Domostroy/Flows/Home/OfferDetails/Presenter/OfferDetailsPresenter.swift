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

    // MARK: - Properties

    weak var view: OfferDetailsViewInput?

    private var offerId: Int

    var picturesAdapter: BaseCollectionManager?

    // MARK: - Init

    init(id: Int) {
        self.offerId = id
    }

}

private extension OfferDetailsPresenter {

    func fetchOffer() {
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
                self?.fillPictures(for: offer)
            }
        }
    }

    func setFavorite(value: Bool, completion: ((Bool) -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            completion?(false)
        }
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

}

// MARK: - OfferDetailsViewOutput

extension OfferDetailsPresenter: OfferDetailsViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
        fetchOffer()
    }

}

