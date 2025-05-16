//
//  EditOfferModuleConfigurator.swift
//  Domostroy
//
//  Editd by igorpustylnik on 15/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class EditOfferModuleConfigurator {

    // swiftlint:disable large_tuple
    func configure() -> (
        EditOfferViewController,
        EditOfferModuleOutput,
        EditOfferModuleInput
    ) {
        let view = EditOfferViewController()
        let presenter = EditOfferPresenter()
        let adapter = view.picturesCollectionView.rddm.baseBuilder
            .add(plugin: .selectable())
            .add(plugin: .highlightable())
            .add(plugin: .accessibility())
            .build()

        presenter.view = view
        view.adapter = adapter
        view.output = presenter

        return (view, presenter, presenter)
    }

}
