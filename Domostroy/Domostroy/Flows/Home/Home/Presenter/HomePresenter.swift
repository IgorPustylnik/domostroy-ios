//
//  HomePresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

final class HomePresenter: HomeModuleOutput {

    // MARK: - HomeModuleOutput

    // MARK: - Properties

    weak var view: HomeViewInput?
}

// MARK: - HomeModuleInput

extension HomePresenter: HomeModuleInput {

}

// MARK: - HomeViewOutput

extension HomePresenter: HomeViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
    }

}
