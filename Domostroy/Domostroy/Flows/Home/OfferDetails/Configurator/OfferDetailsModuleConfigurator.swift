//
//  OfferDetailsModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 10/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class OfferDetailsModuleConfigurator {

    func configure(offerId: Int) -> (
       OfferDetailsViewController,
       OfferDetailsModuleOutput
    ) {
        let view = OfferDetailsViewController()
        let presenter = OfferDetailsPresenter(id: offerId)
        let picturesAdapter = view.picturesCollectionView.rddm.baseBuilder
            .add(plugin: .accessibility())
            .add(plugin: .selectable())
            .build()

        presenter.view = view
        presenter.picturesAdapter = picturesAdapter
        view.output = presenter

        return (view, presenter)
    }

}
