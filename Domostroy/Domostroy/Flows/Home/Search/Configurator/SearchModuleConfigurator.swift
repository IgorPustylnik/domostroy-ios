//
//  SearchModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 11/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class SearchModuleConfigurator {

    func configure(query: String?) -> (
       SearchViewController,
       SearchModuleOutput
    ) {
        let view = SearchViewController()
        let presenter = SearchPresenter(query: query)
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
