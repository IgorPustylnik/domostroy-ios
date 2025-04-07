//
//  CodeConfirmationModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 05/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class CodeConfirmationModuleConfigurator {

    func configure(registerDTO: RegisterDTO) -> (
        CodeConfirmationViewController,
        CodeConfirmationModuleOutput
    ) {
        let view = CodeConfirmationViewController()
        let presenter = CodeConfirmationPresenter(registerDTO: registerDTO)

        presenter.view = view
        view.output = presenter

        return (view, presenter)
    }
}
