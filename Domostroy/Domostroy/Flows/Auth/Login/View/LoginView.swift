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
        static let insets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let vSpacing: CGFloat = 16
    }

    // MARK: - UI Elements

    private lazy var titleLabel: UILabel = {
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        // TODO: Localize
        $0.text = "Login"
        return $0
    }(UILabel())

    private lazy var vStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.vSpacing
        $0.alignment = .fill
        $0.addArrangedSubview(emailTextField)
        $0.addArrangedSubview(passwordTextField)
        return $0
    }(UIStackView())

    private lazy var emailTextField: DValidatableTextField = {
        // TODO: Localize
        $0.configure(placeholder: "Email", correction: .no, keyboardType: .emailAddress, mode: .email)
        $0.setNextResponder(passwordTextField.responder)
        $0.validator = .required(.email)
        return $0
    }(DValidatableTextField())

    private lazy var passwordTextField: DValidatableTextField = {
        // TODO: Localize
        $0.configure(placeholder: "Password", correction: .no, keyboardType: .asciiCapable, mode: .password)
        $0.onShouldReturn = { [weak self] _ in
            self?.login()
        }
        $0.validator = .required(nil)
        return $0
    }(DValidatableTextField())

    // MARK: - Properties

    var onLogin: EmptyClosure?

    var email: String {
        emailTextField.currentText()
    }
    var password: String {
        passwordTextField.currentText()
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
        }
    }

}

// MARK: - Actions

extension LoginView {

    func login() {
        endEditing(true)
        let textFields = vStackView.arrangedSubviews.compactMap { $0 as? DValidatableTextField }
        if textFields.allSatisfy({ $0.isValid() }) {
            onLogin?()
            return
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
        textFields.forEach { $0.isValid() }
    }

}
