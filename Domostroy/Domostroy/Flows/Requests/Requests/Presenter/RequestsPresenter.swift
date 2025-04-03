//
//  RequestsPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

final class RequestsPresenter: RequestsModuleOutput {

    // MARK: - RequestsModuleOutput

    // MARK: - Properties

    weak var view: RequestsViewInput?
}

// MARK: - RequestsModuleInput

extension RequestsPresenter: RequestsModuleInput {

}

// MARK: - RequestsViewOutput

extension RequestsPresenter: RequestsViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
    }

}
