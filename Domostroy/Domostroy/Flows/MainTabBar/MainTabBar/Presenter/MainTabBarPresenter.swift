//
//  MainTabBarPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

final class MainTabBarPresenter: MainTabBarModuleOutput {

    // MARK: - MainTabBarModuleOutput

    // MARK: - Properties

    weak var view: MainTabBarViewInput?
}

// MARK: - MainTabBarModuleInput

extension MainTabBarPresenter: MainTabBarModuleInput {

}

// MARK: - MainTabBarViewOutput

extension MainTabBarPresenter: MainTabBarViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
    }

}
