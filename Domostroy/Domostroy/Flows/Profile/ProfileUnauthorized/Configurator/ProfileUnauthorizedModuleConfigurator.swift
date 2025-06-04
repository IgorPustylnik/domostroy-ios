//
//  ProfileUnauthorizedModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 21/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class ProfileUnauthorizedModuleConfigurator {

    func configure() -> (
       ProfileUnauthorizedViewController,
       ProfileUnauthorizedModuleOutput
    ) {
        let view = ProfileUnauthorizedViewController()
        let presenter = ProfileUnauthorizedPresenter()

        presenter.view = view
        view.output = presenter

        return (view, presenter)
    }

}
