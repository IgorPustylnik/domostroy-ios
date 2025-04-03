//
//  MainTabBarViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class MainTabBarViewController: UIViewController {

    // MARK: - Properties

    private var maintabbarView = MainTabBarView()

    var output: MainTabBarViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
    }

    override func loadView() {
        view = maintabbarView
    }
}

// MARK: - MainTabBarViewInput

extension MainTabBarViewController: MainTabBarViewInput {

    func setupInitialState() {

    }

}
