//
//  HomeModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class HomeModuleConfigurator {

    func configure() -> (
        HomeViewController,
        HomeModuleOutput
    ) {
        let view = HomeViewController()
        let presenter = HomePresenter()

        presenter.view = view
        view.output = presenter

        return (view, presenter)
    }

}
