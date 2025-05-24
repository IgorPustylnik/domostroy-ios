//
//  OffersAdminModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 23/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class OffersAdminModuleConfigurator {

    // swiftlint:disable large_tuple
    func configure() -> (
       OffersAdminViewController,
       OffersAdminModuleOutput,
       OffersAdminModuleInput
    ) {
        let view = OffersAdminViewController()
        let presenter = OffersAdminPresenter()
        let adapter = view.collectionView.rddm.baseBuilder
            .set(dataSource: { DiffableCollectionDataSource(provider: $0) })
            .add(plugin: .paginatable(progressView: view.progressView, output: presenter))
            .add(plugin: .refreshable(refreshControl: view.refreshControl, output: presenter))
            .add(plugin: .accessibility())
            .add(plugin: .highlightable())
            .add(plugin: .selectable())
            .build()

        presenter.view = view
        view.adapter = adapter
        view.output = presenter

        return (view, presenter, presenter)
    }

}
