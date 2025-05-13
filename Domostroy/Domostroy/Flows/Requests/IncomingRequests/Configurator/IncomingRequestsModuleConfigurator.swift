//
//  IncomingRequestsModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 11/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class IncomingRequestsModuleConfigurator {

    func configure() -> (
       IncomingRequestsViewController,
       IncomingRequestsModuleOutput
    ) {
        let view = IncomingRequestsViewController()
        let presenter = IncomingRequestsPresenter()
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

        return (view, presenter)
    }

}
