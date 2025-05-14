//
//  SortModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 22/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class SortModuleConfigurator {

    // swiftlint:disable large_tuple
    func configure() -> (
        SortViewController,
        SortModuleOutput,
        SortModuleInput
    ) {
        let view = SortViewController()
        let presenter = SortPresenter()

        presenter.view = view
        view.output = presenter

        return (view, presenter, presenter)
    }

}
