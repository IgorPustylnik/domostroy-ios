//
//  OfferFilterModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 23/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class OfferFilterModuleConfigurator {

    // swiftlint:disable large_tuple
    func configure() -> (
        OfferFilterViewController,
        OfferFilterModuleOutput,
        OfferFilterModuleInput
    ) {
        let view = OfferFilterViewController()
        let presenter = OfferFilterPresenter()

        presenter.view = view
        view.output = presenter

        return (view, presenter, presenter)
    }

}
