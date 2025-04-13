//
//  MyOffersModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class MyOffersModuleConfigurator {

    func configure() -> (
        MyOffersViewController,
        MyOffersModuleOutput,
        MyOffersModuleInput
    ) {
        let view = MyOffersViewController()
        let presenter = MyOffersPresenter()

        presenter.view = view
        view.output = presenter

        return (view, presenter, presenter)
    }

}
