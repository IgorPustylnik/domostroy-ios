//
//  AuthModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 04/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class AuthModuleConfigurator {

    func configure() -> (
       AuthViewController,
       AuthModuleOutput) {
        let view = AuthViewController()
        let presenter = AuthPresenter()

        presenter.view = view
        view.output = presenter

        return (view, presenter)
    }

}
