//
//  RegisterViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 05/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class RegisterViewController: UIViewController {

    // MARK: - Properties

    private var registerView = RegisterView()

    var output: RegisterViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
        // TODO: Localize
        navigationItem.title = "Register"
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
        view = registerView
        registerView.register = { [weak self] name, surname, phoneNumber, email, password, repeatPassword in
            self?.output?.register(
                name: name,
                surname: surname,
                phoneNumber: phoneNumber,
                email: email,
                password: password,
                repeatPassword: repeatPassword
            )
        }
    }
}

// MARK: - RegisterViewInput

extension RegisterViewController: RegisterViewInput {

    func setupInitialState() {

    }

}
