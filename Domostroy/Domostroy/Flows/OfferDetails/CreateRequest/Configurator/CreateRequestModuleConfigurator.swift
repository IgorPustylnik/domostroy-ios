//
//  CreateRequestModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 17/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class CreateRequestModuleConfigurator {

    func configure() -> (
       CreateRequestViewController,
       CreateRequestModuleOutput,
       CreateRequestModuleInput
    ) {
        let view = CreateRequestViewController()
        let presenter = CreateRequestPresenter()

        presenter.view = view
        view.output = presenter

        return (view, presenter, presenter)
    }

}
