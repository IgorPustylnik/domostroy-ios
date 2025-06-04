//
//  ProfileBannedModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 04/06/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class ProfileBannedModuleConfigurator {

    func configure() -> (
       ProfileBannedViewController,
       ProfileBannedModuleOutput
    ) {
        let view = ProfileBannedViewController()
        let presenter = ProfileBannedPresenter()

        presenter.view = view
        view.output = presenter

        return (view, presenter)
    }

}
