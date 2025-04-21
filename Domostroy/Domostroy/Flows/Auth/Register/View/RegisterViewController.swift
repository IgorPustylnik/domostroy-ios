//
//  RegisterViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 05/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit

final class RegisterViewController: ScrollViewController {

    // MARK: - Constants

    private enum Constants {
        static let buttonInsets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
    }

    // MARK: - UI Elements

    private var registerView = RegisterView()

    private lazy var registerButton: DButton = {
        // TODO: Localize
        $0.title = "Register"
        $0.setAction { [weak self] in
            self?.registerView.register()
        }
        return $0
    }(DButton())

    private var buttonBottomConstraint: Constraint?

    // MARK: - Properties

    var output: RegisterViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
        hidesTabBar = true
        setupKeyboardObservers()
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
        addRegisterButton()
        addDismissButtonIfNeeded()
    }

    override func loadView() {
        super.loadView()
        contentView = registerView
        registerView.onRegister = { [weak self] in
            guard let self else {
                return
            }
            self.output?.register(registerDTO: RegisterDTO(
                firstName: self.registerView.firstName,
                lastName: self.registerView.lastName,
                phoneNumber: self.registerView.phoneNumber,
                email: self.registerView.email,
                password: self.registerView.password)
            )
        }
        registerView.onScrollToActiveView = { [weak self] view
            in
            guard let self, let view else {
                return
            }
            self.scrollToView(view, offsetY: self.registerButton.frame.height)
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

private extension RegisterViewController {

    func addRegisterButton() {
        view.addSubview(registerButton)
        registerButton.snp.makeConstraints { make in
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

// MARK: - RegisterViewInput

extension RegisterViewController: RegisterViewInput {

    func setupInitialState() {

    }

}
