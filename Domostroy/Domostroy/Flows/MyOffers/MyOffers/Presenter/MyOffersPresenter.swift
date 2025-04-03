//
//  MyOffersPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

final class MyOffersPresenter: MyOffersModuleOutput {

    // MARK: - MyOffersModuleOutput

    // MARK: - Properties

    weak var view: MyOffersViewInput?
}

// MARK: - MyOffersModuleInput

extension MyOffersPresenter: MyOffersModuleInput {

}

// MARK: - MyOffersViewOutput

extension MyOffersPresenter: MyOffersViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
    }

}
