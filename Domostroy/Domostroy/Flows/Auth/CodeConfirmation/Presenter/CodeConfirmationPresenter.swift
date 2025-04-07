//
//  CodeConfirmationPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 05/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

final class CodeConfirmationPresenter: CodeConfirmationModuleOutput {

    // MARK: - CodeConfirmationModuleOutput

    // MARK: - Properties

    weak var view: CodeConfirmationViewInput?

    // TODO: Inject
    private var email: String = "igorpustylnik@domostroy.ru"
}

// MARK: - CodeConfirmationModuleInput

extension CodeConfirmationPresenter: CodeConfirmationModuleInput {

}

// MARK: - CodeConfirmationViewOutput

extension CodeConfirmationPresenter: CodeConfirmationViewOutput {

    func viewLoaded() {
        view?.setupInitialState(length: 6, email: email)
    }

}
