//
//  OutgoingRequestDetailsModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 13/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class OutgoingRequestDetailsModuleConfigurator {

    func configure() -> (
       OutgoingRequestDetailsViewController,
       OutgoingRequestDetailsModuleOutput,
       OutgoingRequestDetailsModuleInput
    ) {
        let view = OutgoingRequestDetailsViewController()
        let presenter = OutgoingRequestDetailsPresenter()

        presenter.view = view
        view.output = presenter

        return (view, presenter, presenter)
    }

}
