//
//  HomeViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {

    // MARK: - Properties

    private var homeView = HomeView()

    var output: HomeViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
    }

    override func loadView() {
        view = homeView
    }
}

// MARK: - HomeViewInput

extension HomeViewController: HomeViewInput {

    func setupInitialState() {

    }

}
