//
//  FavoritesModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class FavoritesModuleConfigurator {

    func configure() -> (
       FavoritesViewController,
       FavoritesModuleOutput) {
        let view = FavoritesViewController()
        let presenter = FavoritesPresenter()

        presenter.view = view
        view.output = presenter

        return (view, presenter)
    }

}
