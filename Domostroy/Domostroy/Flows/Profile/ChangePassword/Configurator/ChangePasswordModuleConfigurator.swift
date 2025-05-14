//
//  ChangePasswordModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 14/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class ChangePasswordModuleConfigurator {

    func configure() -> (
       ChangePasswordViewController,
       ChangePasswordModuleOutput
    ) {
        let view = ChangePasswordViewController()
        let presenter = ChangePasswordPresenter()

        presenter.view = view
        view.output = presenter

        return (view, presenter)
    }

}
