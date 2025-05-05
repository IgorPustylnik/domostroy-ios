//
//  OfferDetailsModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 10/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class OfferDetailsModuleConfigurator {

    func configure() -> (
       OfferDetailsViewController,
       OfferDetailsModuleOutput,
       OfferDetailsModuleInput
    ) {
        let view = OfferDetailsViewController()
        let presenter = OfferDetailsPresenter()
        let picturesAdapter = view.picturesCollectionView.rddm.baseBuilder
            .add(plugin: .accessibility())
            .add(plugin: .selectable())
            .build()

        presenter.view = view
        view.picturesAdapter = picturesAdapter
        view.output = presenter

        return (view, presenter, presenter)
    }

}
