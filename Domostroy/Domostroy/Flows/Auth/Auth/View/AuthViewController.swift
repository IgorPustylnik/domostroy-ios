//
//  AuthViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 04/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class AuthViewController: ScrollViewController {

    // MARK: - Properties

    private var authView = AuthView()

    var output: AuthViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.alwaysBounceVertical = true
        output?.viewLoaded()
    }

    override func loadView() {
        super.loadView()
        contentView = authView
        authView.login = { [weak self] in self?.output?.login() }
        authView.register = { [weak self] in self?.output?.register() }
    }
}

// MARK: - AuthViewInput

extension AuthViewController: AuthViewInput {

    func setupInitialState() {

    }

}
