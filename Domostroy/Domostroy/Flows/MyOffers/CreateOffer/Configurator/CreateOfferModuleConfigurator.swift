//
//  CreateOfferModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 15/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class CreateOfferModuleConfigurator {

    func configure() -> (
        CreateOfferViewController,
        CreateOfferModuleOutput,
        CreateOfferModuleInput
    ) {
        let view = CreateOfferViewController()
        let presenter = CreateOfferPresenter()
        let adapter = view.picturesCollectionView.rddm.baseBuilder
            .add(plugin: .selectable())
            .add(plugin: .highlightable())
            .add(plugin: .accessibility())
            .build()

        presenter.view = view
        presenter.adapter = adapter
        view.output = presenter

        return (view, presenter, presenter)
    }

}
