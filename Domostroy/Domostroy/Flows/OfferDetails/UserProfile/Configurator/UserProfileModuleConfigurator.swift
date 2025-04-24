//
//  UserProfileModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 24/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class UserProfileModuleConfigurator {

    func configure() -> (
        UserProfileViewController,
        UserProfileModuleOutput,
        UserProfileModuleInput
    ) {
        let view = UserProfileViewController()
        let presenter = UserProfilePresenter()
        let adapter = view.collectionView.rddm.baseBuilder
            .set(dataSource: { DiffableCollectionDataSource(provider: $0) })
            .set(delegate: FlowCollectionDelegate())
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
