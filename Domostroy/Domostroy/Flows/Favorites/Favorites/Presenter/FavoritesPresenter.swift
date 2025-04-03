//
//  FavoritesPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

final class FavoritesPresenter: FavoritesModuleOutput {

    // MARK: - FavoritesModuleOutput

    // MARK: - Properties

    weak var view: FavoritesViewInput?
}

// MARK: - FavoritesModuleInput

extension FavoritesPresenter: FavoritesModuleInput {

}

// MARK: - FavoritesViewOutput

extension FavoritesPresenter: FavoritesViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
    }

}
