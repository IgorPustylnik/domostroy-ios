//
//  AdminPanelModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 21/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class AdminPanelModuleConfigurator {

    // swiftlint:disable large_tuple
    func configure() -> (
        AdminPanelViewController,
        AdminPanelModuleOutput,
        AdminPanelModuleInput
    ) {
        let view = AdminPanelViewController()
        let presenter = AdminPanelPresenter()

        presenter.view = view
        view.output = presenter

        return (view, presenter, presenter)
    }

}
