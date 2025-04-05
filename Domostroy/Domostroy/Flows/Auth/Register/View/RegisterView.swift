//
//  RegisterView.swift
//  Domostroy
//
//  Created by igorpustylnik on 05/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit

final class RegisterView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let vSpacing: CGFloat = 16
        static let hInset: CGFloat = 16
        static let animationDuration: Double = 0.3
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
        $0.addArrangedSubview(nameTextField)
        $0.addArrangedSubview(surnameTextField)
        $0.addArrangedSubview(phoneNumberTextField)
        $0.addArrangedSubview(emailTextField)
        $0.addArrangedSubview(passwordTextField)
        $0.addArrangedSubview(repeatPasswordTextField)
        return $0
    }(UIStackView())

    // MARK: - TextFields

    private lazy var nameTextField: DTextFieldView = {
        // TODO: Localize
        $0.configure(placeholder: "Name", correction: .yes, keyboardType: .default, mode: .name)
        $0.setNextResponder(surnameTextField.responder)
        $0.validator = .required(.username)
        $0.onBeginEditing = { [weak self] _ in
            self?.activeView = self?.nameTextField
            self?.scrollToActiveView(Constants.animationDuration)
        }
        return $0
    }(DTextFieldView())

    private lazy var surnameTextField: DTextFieldView = {
        // TODO: Localize and make actually optional
        $0.configure(placeholder: "Surname (optional)", correction: .yes, keyboardType: .default, mode: .surname)
        $0.setNextResponder(phoneNumberTextField.responder)
        $0.validator = .optional(.username)
        $0.onBeginEditing = { [weak self] _ in
            self?.activeView = self?.surnameTextField
            self?.scrollToActiveView(Constants.animationDuration)
        }
        return $0
    }(DTextFieldView())

    private lazy var phoneNumberTextField: DTextFieldView = {
        // TODO: Localize
        $0.configure(placeholder: "Phone number (optional)", correction: .no, keyboardType: .phonePad, mode: .phoneNumber)
        $0.setNextResponder(emailTextField.responder)
        $0.validator = .optional(.phone(RussianPhoneNumberNormalizer()))
        $0.onBeginEditing = { [weak self] _ in
            self?.activeView = self?.phoneNumberTextField
            self?.scrollToActiveView(Constants.animationDuration)
        }
        return $0
    }(DTextFieldView())

    private lazy var emailTextField: DTextFieldView = {
        // TODO: Localize
        $0.configure(placeholder: "Email", correction: .no, keyboardType: .emailAddress, mode: .email)
        $0.setNextResponder(passwordTextField.responder)
        $0.validator = .required(.email)
        $0.onBeginEditing = { [weak self] _ in
            self?.activeView = self?.emailTextField
            self?.scrollToActiveView(Constants.animationDuration)
        }
        return $0
    }(DTextFieldView())

    private lazy var passwordTextField: DTextFieldView = {
        // TODO: Localize
        $0.configure(placeholder: "Password", correction: .no, keyboardType: .asciiCapable, mode: .password)
        $0.setNextResponder(repeatPasswordTextField.responder)
        $0.validator = .required(.password)
        $0.onEndEditing = { [weak self] _ in
            self?.repeatPasswordTextField.validator = .required(.match(
                password: self?.passwordTextField.currentText() ?? ""
                )
            )
        }
        $0.onBeginEditing = { [weak self] _ in
            self?.activeView = self?.passwordTextField
            self?.scrollToActiveView(Constants.animationDuration)
        }
        return $0
    }(DTextFieldView())

    private lazy var repeatPasswordTextField: DTextFieldView = {
        // TODO: Localize
        $0.configure(placeholder: "Repeat password", correction: .no, keyboardType: .asciiCapable, mode: .password)
        $0.onShouldReturn = { [weak self] _ in
            self?.onRegister()
        }
        $0.onBeginEditing = { [weak self] _ in
            self?.activeView = self?.repeatPasswordTextField
            self?.scrollToActiveView(Constants.animationDuration)
        }
        $0.validator = .required(.match(password: ""))
        return $0
    }(DTextFieldView())

    private lazy var registerButton: DButton = {
        // TODO: Localize
        $0.title = "Register"
        $0.setAction { [weak self] in
            self?.onRegister()
        }
        return $0
    }(DButton())

    // MARK: - Properties

    var register: ((String, String, String, String, String, String) -> Void)?

    private var buttonBottomConstraint: Constraint?
    private var activeView: UIView?
    private var keyboardHeight: CGFloat?

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
        contentView.addSubview(registerButton)
        vStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView).inset(Constants.vSpacing)
        }
        registerButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(Constants.hInset)
            buttonBottomConstraint = make.bottom
                .equalTo(safeAreaLayoutGuide.snp.bottom).offset(-Constants.vSpacing).constraint
        }
    }

}

// MARK: - Keyboard

private extension RegisterView {

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
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        let keyboardHeight = keyboardFrame.height
        self.keyboardHeight = keyboardHeight

        UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseInOut) {
            self.buttonBottomConstraint?.update(offset: -keyboardHeight + Constants.vSpacing)
            self.layoutIfNeeded()
        }
    }

    @objc
    func keyboardWillHide(notification: Notification) {
        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseInOut) { [weak self] in
                self?.scrollView.contentInset.bottom = .zero
                self?.scrollView.verticalScrollIndicatorInsets.bottom = .zero
                self?.buttonBottomConstraint?.update(offset: -Constants.vSpacing)
                self?.layoutIfNeeded()
            }
        }
    }

    func scrollToActiveView(_ duration: Double) {
        guard let keyboardHeight = self.keyboardHeight, let activeView = self.activeView else {
            return
        }

        let convertedFrame = activeView.convert(activeView.bounds, to: self)
        let visibleRectHeight = scrollView.bounds.height - keyboardHeight - 30
        let activeBottom = convertedFrame.maxY

        if activeBottom > visibleRectHeight - 100 {
            let offsetY = activeBottom - visibleRectHeight + Constants.vSpacing
            UIView.animate(withDuration: duration) {
                self.scrollView.contentInset.bottom = keyboardHeight
                self.scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
                self.scrollView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: false)
            }
        }
    }
}

// MARK: - Private methods

private extension RegisterView {

    func onRegister() {
        register?(
            nameTextField.currentText(),
            surnameTextField.currentText(),
            phoneNumberTextField.currentText(),
            emailTextField.currentText(),
            passwordTextField.currentText(),
            repeatPasswordTextField.currentText()
        )
        nameTextField.isValid()
        surnameTextField.isValid()
        phoneNumberTextField.isValid()
        emailTextField.isValid()
        passwordTextField.isValid()
        repeatPasswordTextField.isValid()
        endEditing(true)
    }

}
