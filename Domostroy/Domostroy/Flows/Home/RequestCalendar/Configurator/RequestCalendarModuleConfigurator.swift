//
//  RequestCalendarModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 17/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import HorizonCalendar

final class RequestCalendarModuleConfigurator {

    func configure() -> (
        RequestCalendarViewController,
        RequestCalendarModuleOutput,
        RequestCalendarModuleInput
    ) {
        let view = RequestCalendarViewController()
        let presenter = RequestCalendarPresenter()

        presenter.view = view
        view.output = presenter

        return (view, presenter, presenter)
    }

}
