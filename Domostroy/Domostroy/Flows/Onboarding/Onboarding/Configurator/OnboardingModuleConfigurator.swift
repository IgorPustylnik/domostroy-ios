//
//  OnboardingModuleConfigurator.swift
//  Domostroy
//
//  Created by igorpustylnik on 31/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class OnboardingModuleConfigurator {

    func configure() -> (
       OnboardingViewController,
       OnboardingModuleOutput
    ) {
        let view = OnboardingViewController()
        let presenter = OnboardingPresenter()
        let adapter = view.collectionView.rddm.baseBuilder
            .add(plugin: .accessibility())
            .add(plugin: view.collectionScrollDelegateProxy)
            .build()

        presenter.view = view
        view.adapter = adapter
        view.output = presenter

        return (view, presenter)
    }

}
