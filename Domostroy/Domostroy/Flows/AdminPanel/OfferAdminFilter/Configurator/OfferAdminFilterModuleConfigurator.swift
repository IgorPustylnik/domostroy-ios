//
//  OfferAdminFilterModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 23/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class OfferAdminFilterModuleConfigurator {

    // swiftlint:disable large_tuple
    func configure() -> (
       OfferAdminFilterViewController,
       OfferAdminFilterModuleOutput,
       OfferAdminFilterModuleInput
    ) {
        let view = OfferAdminFilterViewController()
        let presenter = OfferAdminFilterPresenter()

        presenter.view = view
        view.output = presenter

        return (view, presenter, presenter)
    }

}
