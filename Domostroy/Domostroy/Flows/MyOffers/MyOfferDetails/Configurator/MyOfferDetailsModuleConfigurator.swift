//
//  MyOfferDetailsModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 15/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import ReactiveDataDisplayManager

final class MyOfferDetailsModuleConfigurator {

    // swiftlint:disable large_tuple
    func configure() -> (
       MyOfferDetailsViewController,
       MyOfferDetailsModuleOutput,
       MyOfferDetailsModuleInput
    ) {
        let view = MyOfferDetailsViewController()
        let presenter = MyOfferDetailsPresenter()
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
