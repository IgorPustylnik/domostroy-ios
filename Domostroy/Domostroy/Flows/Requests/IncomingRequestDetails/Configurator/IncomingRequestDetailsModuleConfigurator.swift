//
//  IncomingRequestDetailsModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 13/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class IncomingRequestDetailsModuleConfigurator {

    // swiftlint:disable large_tuple
    func configure() -> (
       IncomingRequestDetailsViewController,
       IncomingRequestDetailsModuleOutput,
       IncomingRequestDetailsModuleInput
    ) {
        let view = IncomingRequestDetailsViewController()
        let presenter = IncomingRequestDetailsPresenter()

        presenter.view = view
        view.output = presenter

        return (view, presenter, presenter)
    }

}
