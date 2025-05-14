//
//  EditProfileModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 14/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class EditProfileModuleConfigurator {

    func configure() -> (
       EditProfileViewController,
       EditProfileModuleOutput
    ) {
        let view = EditProfileViewController()
        let presenter = EditProfilePresenter()

        presenter.view = view
        view.output = presenter

        return (view, presenter)
    }

}
