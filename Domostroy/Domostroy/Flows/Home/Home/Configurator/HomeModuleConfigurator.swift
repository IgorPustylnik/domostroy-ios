//
//  HomeModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class HomeModuleConfigurator {

    func configure() -> (
        HomeViewController,
        HomeModuleOutput
    ) {
        let view = HomeViewController()
        let presenter = HomePresenter()
        let adapter = view.collectionView.rddm.baseBuilder
            .set(dataSource: { DiffableCollectionDataSource(provider: $0) })
            .add(plugin: .paginatable(progressView: view.progressView, output: presenter))
            .add(plugin: .refreshable(refreshControl: view.refreshControl, output: presenter))
            .add(plugin: .accessibility())
            .add(plugin: .highlightable())
            .add(plugin: .selectable())
            .build()

        presenter.view = view
        presenter.adapter = adapter
        view.output = presenter

        return (view, presenter)
    }

}
