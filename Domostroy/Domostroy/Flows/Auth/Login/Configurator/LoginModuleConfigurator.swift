//
//  LoginModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 04/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class LoginModuleConfigurator {

    func configure() -> (
       LoginViewController,
       LoginModuleOutput) {
        let view = LoginViewController()
        let presenter = LoginPresenter()

        presenter.view = view
        view.output = presenter

        return (view, presenter)
    }

}
