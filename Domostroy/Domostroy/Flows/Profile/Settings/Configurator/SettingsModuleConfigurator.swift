//
//  SettingsModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 18/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class SettingsModuleConfigurator {

    func configure() -> (
       SettingsViewController,
       SettingsModuleOutput
    ) {
        let view = SettingsViewController()
        let presenter = SettingsPresenter()
        let adapter = view.tableView.rddm.manualBuilder
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
