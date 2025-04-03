//
//  ProfileModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class ProfileModuleConfigurator {

    func configure() -> (
       ProfileViewController,
       ProfileModuleOutput) {
        let view = ProfileViewController()
        let presenter = ProfilePresenter()

        presenter.view = view
        view.output = presenter

        return (view, presenter)
    }

}
