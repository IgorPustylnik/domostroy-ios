//
//  FavoritesModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class FavoritesModuleConfigurator {

    // swiftlint:disable large_tuple
    func configure() -> (
        FavoritesViewController,
        FavoritesModuleOutput,
        FavoritesModuleInput
    ) {
        let view = FavoritesViewController()
        let presenter = FavoritesPresenter()
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
