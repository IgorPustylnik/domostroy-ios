//
//  LoginView.swift
//  Domostroy
//
//  Created by igorpustylnik on 04/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit

final class LoginView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let vSpacing: CGFloat = 16
        static let hInset: CGFloat = 16
    }

    // MARK: - UI Elements

    private lazy var scrollView: UIScrollView = {
        $0.keyboardDismissMode = .onDrag
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = true
        return $0
    }(UIScrollView())

    private lazy var contentView: UIView = {
        return $0
    }(UIView())

    private lazy var vStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.vSpacing
        $0.alignment = .fill
        $0.addArrangedSubview(emailTextField)
        $0.addArrangedSubview(passwordTextField)
        return $0
    }(UIStackView())

    private lazy var emailTextField: DTextFieldView = {
        // TODO: Localize
        $0.configure(placeholder: "Email", correction: .no, keyboardType: .emailAddress, mode: .email)
        $0.setNextResponder(passwordTextField.responder)
        $0.validator = .required(.email)
        return $0
    }(DTextFieldView())

    private lazy var passwordTextField: DTextFieldView = {
        // TODO: Localize
        $0.configure(placeholder: "Password", correction: .no, keyboardType: .asciiCapable, mode: .password)
        $0.onShouldReturn = { [weak self] _ in
            self?.onLogin()
        }
        $0.validator = .required(nil)
        return $0
    }(DTextFieldView())

    private lazy var loginButton: DButton = {
        // TODO: Localize
        $0.title = "Login"
        $0.setAction { [weak self] in
            self?.onLogin()
        }
        return $0
    }(DButton())

    // MARK: - Properties

    var login: ((String, String) -> Void)?

    private var buttonBottomConstraint: Constraint?

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupUI()
        setupKeyboardObservers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupKeyboardObservers()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - UI Setup

    private func setupUI() {
        backgroundColor = .systemBackground
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView.safeAreaLayoutGuide)
            make.size.equalTo(scrollView.safeAreaLayoutGuide)
        }
        contentView.addSubview(vStackView)
        contentView.addSubview(loginButton)
        vStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView).inset(Constants.vSpacing)
        }
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(Constants.hInset)
            buttonBottomConstraint = make.bottom
                .equalTo(safeAreaLayoutGuide.snp.bottom).offset(-Constants.vSpacing).constraint
        }
    }

}

private extension LoginView {

    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }

    @objc
    func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
           let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {

            let keyboardHeight = keyboardFrame.height

            UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseInOut) {
                self.buttonBottomConstraint?.update(offset: -keyboardHeight + Constants.vSpacing)
                self.layoutIfNeeded()
            }
        }
    }

    @objc
    func keyboardWillHide(notification: Notification) {
        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseInOut) { [weak self] in
                self?.buttonBottomConstraint?.update(offset: -Constants.vSpacing)
                self?.layoutIfNeeded()
            }
        }
    }
}

// MARK: - Private methods

private extension LoginView {

    func onLogin() {
        login?(
            emailTextField.currentText(),
            passwordTextField.currentText()
        )
        emailTextField.isValid()
        passwordTextField.isValid()
        endEditing(true)
    }

}
