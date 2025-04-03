//
//  MyOffersViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class MyOffersViewController: UIViewController {

    // MARK: - Properties

    private var myoffersView = MyOffersView()

    var output: MyOffersViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
    }

    override func loadView() {
        view = myoffersView
    }
}

// MARK: - MyOffersViewInput

extension MyOffersViewController: MyOffersViewInput {

    func setupInitialState() {

    }

}
