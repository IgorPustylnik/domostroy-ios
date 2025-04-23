//
//  FilterModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 23/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class FilterModuleConfigurator {

    func configure() -> (
        FilterViewController,
        FilterModuleOutput,
        FilterModuleInput
    ) {
        let view = FilterViewController()
        let presenter = FilterPresenter()

        presenter.view = view
        view.output = presenter

        return (view, presenter, presenter)
    }

}
