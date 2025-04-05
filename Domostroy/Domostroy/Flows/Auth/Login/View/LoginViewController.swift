//
//  LoginViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 04/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class LoginViewController: BaseViewController {

    // MARK: - Properties

    private var loginView = LoginView()

    var output: LoginViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
        // TODO: Localize
        navigationBar.title = "Login"
        hidesTabBar = true
    }

    override func loadView() {
        view = loginView
        loginView.login = { [weak self] email, password in
            self?.output?.login(email: email, password: password)
        }
        loginView.setScrollViewDelegate(self)
    }
}

// MARK: - LoginViewInput

extension LoginViewController: LoginViewInput {

    func setupInitialState() {

    }

}
