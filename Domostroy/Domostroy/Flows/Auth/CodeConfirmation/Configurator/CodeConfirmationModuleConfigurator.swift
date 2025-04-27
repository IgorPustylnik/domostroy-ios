//
//  CodeConfirmationModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 05/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class CodeConfirmationModuleConfigurator {

    func configure(registerEntity: RegisterEntity) -> (
        CodeConfirmationViewController,
        CodeConfirmationModuleOutput
    ) {
        let view = CodeConfirmationViewController()
        let presenter = CodeConfirmationPresenter(registerEntity: registerEntity)

        presenter.view = view
        view.output = presenter

        return (view, presenter)
    }
}
