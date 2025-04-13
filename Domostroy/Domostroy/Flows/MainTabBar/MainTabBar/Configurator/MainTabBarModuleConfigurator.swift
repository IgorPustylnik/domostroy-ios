//
//  MainTabBarModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class MainTabBarModuleConfigurator {

    func configure() -> (
        MainTabBarViewController,
        MainTabBarModuleOutput,
        MainTabBarModuleInput
    ) {
        let view = MainTabBarViewController()
        let presenter = MainTabBarPresenter()

        presenter.view = view
        view.output = presenter

        presenter.configureTabs()

        return (view, presenter, presenter)
    }

}
