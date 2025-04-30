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
        static let insets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let vSpacing: CGFloat = 16
    }

    // MARK: - UI Elements

    private lazy var titleLabel: UILabel = {
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.text = L10n.Localizable.Auth.Register.title
        return $0
    }(UILabel())

    private lazy var vStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.vSpacing
        $0.alignment = .fill
        $0.addArrangedSubview(firstNameTextField)
        $0.addArrangedSubview(lastNameTextField)
        $0.addArrangedSubview(phoneNumberTextField)
        $0.addArrangedSubview(emailTextField)
        $0.addArrangedSubview(passwordTextField)
        $0.addArrangedSubview(repeatPasswordTextField)
        return $0
    }(UIStackView())

    // MARK: - TextFields

    private lazy var firstNameTextField: DValidatableTextField = {
        $0.configure(
            placeholder: L10n.Localizable.Auth.Register.Placeholder.firstName,
            correction: .yes,
            keyboardType: .default,
            mode: .firstName
        )
        $0.setNextResponder(lastNameTextField.responder)
        $0.validator = RequiredValidator(UsernameValidator())
        $0.onBeginEditing = { [weak self] _ in
            self?.onScrollToActiveView?(self?.firstNameTextField)
        }
        return $0
    }(DValidatableTextField())

    private lazy var lastNameTextField: DValidatableTextField = {
        $0.configure(
            placeholder: L10n.Localizable.Auth.Register.Placeholder.lastName,
            correction: .yes,
            keyboardType: .default,
            mode: .lastName
        )
        $0.setNextResponder(phoneNumberTextField.responder)
        $0.validator = OptionalValidator(UsernameValidator())
        $0.onBeginEditing = { [weak self] _ in
            self?.onScrollToActiveView?(self?.lastNameTextField)
        }
        return $0
    }(DValidatableTextField())

    private lazy var phoneNumberTextField: DValidatableTextField = {
        $0.configure(
            placeholder: L10n.Localizable.Auth.Register.Placeholder.phoneNumber,
            correction: .no,
            keyboardType: .phonePad,
            mode: .phoneNumber
        )
        $0.setNextResponder(emailTextField.responder)
        $0.validator = RequiredValidator(PhoneValidator(normalizer: RussianPhoneNumberNormalizer()))
        $0.onBeginEditing = { [weak self] _ in
            self?.onScrollToActiveView?(self?.phoneNumberTextField)
        }
        return $0
    }(DValidatableTextField())

    private lazy var emailTextField: DValidatableTextField = {
        $0.configure(
            placeholder: L10n.Localizable.Auth.Register.Placeholder.email,
            correction: .no,
            keyboardType: .emailAddress,
            mode: .email
        )
        $0.setNextResponder(passwordTextField.responder)
        $0.validator = RequiredValidator(EmailValidator())
        $0.onBeginEditing = { [weak self] _ in
            self?.onScrollToActiveView?(self?.emailTextField)
        }
        return $0
    }(DValidatableTextField())

    private lazy var passwordTextField: DValidatableTextField = {
        $0.configure(
            placeholder: L10n.Localizable.Auth.Register.Placeholder.password,
            correction: .no,
            keyboardType: .asciiCapable,
            mode: .password
        )
        $0.setNextResponder(repeatPasswordTextField.responder)
        $0.validator = RequiredValidator(PasswordValidator())
        $0.onEndEditing = { [weak self] _ in
            self?.repeatPasswordTextField.validator = RequiredValidator(
                MatchPasswordValidator(password: self?.passwordTextField.currentText() ?? "")
            )
        }
        $0.onBeginEditing = { [weak self] _ in
            self?.onScrollToActiveView?(self?.passwordTextField)
        }
        return $0
    }(DValidatableTextField())

    private lazy var repeatPasswordTextField: DValidatableTextField = {
        $0.configure(
            placeholder: L10n.Localizable.Auth.Register.Placeholder.repeatPassword,
            correction: .no,
            keyboardType: .asciiCapable,
            mode: .password
        )
        $0.onShouldReturn = { [weak self] _ in
            self?.register()
        }
        $0.onBeginEditing = { [weak self] _ in
            self?.onScrollToActiveView?(self?.repeatPasswordTextField)
        }
        $0.validator = RequiredValidator(MatchPasswordValidator(password: ""))
        return $0
    }(DValidatableTextField())

    // MARK: - Properties

    var onRegister: EmptyClosure?

    var onScrollToActiveView: ((UIView?) -> Void)?

    var firstName: String {
        firstNameTextField.currentText()
    }
    var lastName: String {
        lastNameTextField.currentText()
    }
    var phoneNumber: String {
        phoneNumberTextField.currentText()
    }
    var email: String {
        emailTextField.currentText()
    }
    var password: String {
        passwordTextField.currentText()
    }
    var repeatPassword: String {
        repeatPasswordTextField.currentText()
    }

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - UI Setup

    private func setupUI() {
        backgroundColor = .systemBackground
        addSubview(titleLabel)
        addSubview(vStackView)
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(Constants.insets)
        }
        vStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.vSpacing)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(Constants.vSpacing)
            make.bottom.equalToSuperview()
        }
    }

}

// MARK: - Actions

extension RegisterView {

    func register() {
        endEditing(true)
        let textFields = vStackView.arrangedSubviews.compactMap { $0 as? DValidatableTextField }
        if textFields.allSatisfy({ $0.isValid() }) {
            onRegister?()
            return
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
        textFields.forEach { $0.isValid() }
    }

}
