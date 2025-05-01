//
//  LoginViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 04/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit

final class LoginViewController: ScrollViewController {

    // MARK: - Constants

    private enum Constants {
        static let buttonInsets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
    }

    // MARK: - UI Elements

    private var loginView = LoginView()

    private lazy var loginButton: DButton = {
        $0.title = L10n.Localizable.Auth.Login.Button.login
        $0.setAction { [weak self] in
            self?.loginView.login()
        }
        return $0
    }(DButton())

    private var buttonBottomConstraint: Constraint?

    // MARK: - Properties

    var output: LoginViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
        hidesTabBar = true
        setupKeyboardObservers()
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
        addLoginButton()
        addDismissButtonIfNeeded()
    }

    override func loadView() {
        super.loadView()
        contentView = loginView
        loginView.onLogin = { [weak self] in
            guard let self else {
                return
            }
            self.output?.login(
                email: self.loginView.email,
                password: self.loginView.password
            )
        }
    }

    override func keyboardWillShow(notification: Notification) {
        super.keyboardWillShow(notification: notification)
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut) {
            self.buttonBottomConstraint?.update(offset: -self.keyboardHeight + 16)
            self.view.layoutIfNeeded()
        }
    }

    override func keyboardWillHide(notification: Notification) {
        super.keyboardWillHide(notification: notification)
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut) {
            self.buttonBottomConstraint?.update(offset: -Constants.buttonInsets.bottom)
        }
    }
}

// MARK: - Private methods

private extension LoginViewController {

    func addLoginButton() {
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Constants.buttonInsets)
            buttonBottomConstraint = make.bottom
                .equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-Constants.buttonInsets.bottom).constraint
        }
    }

    func addDismissButtonIfNeeded() {
        let isModalInNav = presentingViewController != nil &&
            navigationController?.viewControllers.first == self
        if isModalInNav {
            navigationBar.addButtonToLeft(
                image: UIImage(systemName: "xmark")?.withTintColor(
                    .Domostroy.primary,
                    renderingMode: .alwaysOriginal
                )
            ) { [weak self] in
                self?.output?.dismiss()
            }
        }
    }

}

// MARK: - LoginViewInput

extension LoginViewController: LoginViewInput {

    func setupInitialState() {

    }

    func setActivity(isLoading: Bool) {
        loginButton.setLoading(isLoading)
    }

}
