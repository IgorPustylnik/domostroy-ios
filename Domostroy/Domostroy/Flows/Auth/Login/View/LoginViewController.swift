//
//  LoginViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 04/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {

    // MARK: - Properties

    private var loginView = LoginView()

    var output: LoginViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
        // TODO: Localize
        navigationItem.title = "Login"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (tabBarController as? MainTabBarViewController)?.setTabBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (tabBarController as? MainTabBarViewController)?.setTabBarHidden(false, animated: true)
    }

    override func loadView() {
        view = loginView
        loginView.login = { [weak self] email, password in
            self?.output?.login(email: email, password: password)
        }
    }
}

// MARK: - LoginViewInput

extension LoginViewController: LoginViewInput {

    func setupInitialState() {

    }

}
