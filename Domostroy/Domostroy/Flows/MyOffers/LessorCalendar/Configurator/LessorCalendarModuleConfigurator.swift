//
//  LessorCalendarModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 25/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class LessorCalendarModuleConfigurator {

    // swiftlint:disable large_tuple
    func configure() -> (
        LessorCalendarViewController,
        LessorCalendarModuleOutput,
        LessorCalendarModuleInput
    ) {
        let view = LessorCalendarViewController()
        let presenter = LessorCalendarPresenter()

        presenter.view = view
        view.output = presenter

        return (view, presenter, presenter)
    }

}
