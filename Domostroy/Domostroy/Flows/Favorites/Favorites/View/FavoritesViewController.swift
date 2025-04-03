//
//  FavoritesViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class FavoritesViewController: UIViewController {

    // MARK: - Properties

    private var favoritesView = FavoritesView()

    var output: FavoritesViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
    }

    override func loadView() {
        view = favoritesView
    }
}

// MARK: - FavoritesViewInput

extension FavoritesViewController: FavoritesViewInput {

    func setupInitialState() {

    }

}
