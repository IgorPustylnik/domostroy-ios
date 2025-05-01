//
//  SelectCityModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 01/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class SelectCityModuleConfigurator {

    func configure() -> (
       SelectCityViewController,
       SelectCityModuleOutput,
       SelectCityModuleInput
    ) {
        let view = SelectCityViewController()
        let presenter = SelectCityPresenter()
        let adapter = view.tableView.rddm.manualBuilder
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
