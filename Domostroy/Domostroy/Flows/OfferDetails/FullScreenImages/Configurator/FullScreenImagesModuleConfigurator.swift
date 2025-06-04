//
//  FullScreenImagesModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 01/06/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class FullScreenImagesModuleConfigurator {

    // swiftlint:disable large_tuple
    func configure() -> (
       FullScreenImagesViewController,
       FullScreenImagesModuleOutput,
       FullScreenImagesModuleInput
    ) {
        let view = FullScreenImagesViewController()
        let presenter = FullScreenImagesPresenter()
        let adapter = view.collectionView.rddm.baseBuilder
            .add(plugin: .accessibility())
            .add(plugin: view.scrollDelegateProxy)
            .build()

        presenter.view = view
        view.adapter = adapter
        view.output = presenter

        return (view, presenter, presenter)
    }

}
