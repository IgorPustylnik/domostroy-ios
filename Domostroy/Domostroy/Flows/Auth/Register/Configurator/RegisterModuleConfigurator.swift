//
//  RegisterModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 05/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class RegisterModuleConfigurator {

    func configure() -> (
        RegisterViewController,
        RegisterModuleOutput
    ) {
        let view = RegisterViewController()
        let presenter = RegisterPresenter()

        presenter.view = view
        view.output = presenter

        return (view, presenter)
    }

}
