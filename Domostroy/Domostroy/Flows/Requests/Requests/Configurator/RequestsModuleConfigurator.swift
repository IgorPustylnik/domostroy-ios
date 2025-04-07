//
//  RequestsModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class RequestsModuleConfigurator {

    func configure() -> (
        RequestsViewController,
        RequestsModuleOutput
    ) {
        let view = RequestsViewController()
        let presenter = RequestsPresenter()

        presenter.view = view
        view.output = presenter

        return (view, presenter)
    }

}
