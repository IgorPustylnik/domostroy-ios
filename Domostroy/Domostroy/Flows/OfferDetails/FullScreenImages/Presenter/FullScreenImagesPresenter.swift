//
//  FullScreenImagesPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 01/06/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation
import Kingfisher

final class FullScreenImagesPresenter: FullScreenImagesModuleOutput {

    // MARK: - FullScreenImagesModuleOutput

    var onDismiss: EmptyClosure?
    var onScrollTo: ((Int) -> Void)?

    // MARK: - Properties

    private var imagesUrls: [URL] = []
    private var currentIndex = 0

    weak var view: FullScreenImagesViewInput?
}

// MARK: - FullScreenImagesModuleInput

extension FullScreenImagesPresenter: FullScreenImagesModuleInput {

    func setImages(urls: [URL], initialIndex: Int) {
        imagesUrls = urls
        guard initialIndex < urls.count else {
            return
        }
        currentIndex = initialIndex
        view?.setup(
            with: imagesUrls.map { url in
                    .init { imageView, completion in
                        DispatchQueue.main.async {
                            imageView.kf.setImage(with: url) { _ in
                                completion()
                            }
                        }
                    }
            },
            initialIndex: currentIndex
        )
        view?.setNavigationTitle(
            L10n.Localizable.FullScreenImages.outOf(
                currentIndex + 1,
                imagesUrls.count
            )
        )
    }

}

// MARK: - FullScreenImagesViewOutput

extension FullScreenImagesPresenter: FullScreenImagesViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
    }

    func scrolledTo(index: Int) {
        currentIndex = index
        onScrollTo?(index)
        view?.setNavigationTitle(
            L10n.Localizable.FullScreenImages.outOf(
                currentIndex + 1,
                imagesUrls.count
            )
        )
    }

    func dismiss() {
        onDismiss?()
    }

}
