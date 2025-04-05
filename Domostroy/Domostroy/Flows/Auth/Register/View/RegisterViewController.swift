//
//  RegisterViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 05/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class RegisterViewController: BaseViewController {

    // MARK: - Properties

    private var registerView = RegisterView()

    var output: RegisterViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
        // TODO: Localize
        navigationBar.title = "Register"
        hidesTabBar = true
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
        registerView.setScrollViewDelegate(self)
    }
}

// MARK: - RegisterViewInput

extension RegisterViewController: RegisterViewInput {

    func setupInitialState() {

    }

}
