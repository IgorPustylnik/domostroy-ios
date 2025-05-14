//
//  ChangePasswordView.swift
//  Domostroy
//
//  Created by igorpustylnik on 14/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit

final class ChangePasswordView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let insets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let mainVStackSpacing: CGFloat = 16
    }

    // MARK: - UI Elements

    private lazy var mainVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.mainVStackSpacing
        $0.addArrangedSubview(oldPasswordTextField)
        $0.addArrangedSubview(newPasswordTextField)
        $0.addArrangedSubview(repeatNewPasswordTextField)
        $0.addArrangedSubview(saveButton)
        return $0
    }(UIStackView())

    private lazy var oldPasswordTextField: DValidatableTextField = {
        $0.configure(
            placeholder: L10n.Localizable.Profile.ChangePassword.Placeholder.oldPassword,
            correction: .no,
            keyboardType: .asciiCapable,
            mode: .password
        )
        $0.onTextChange = { [weak self] text in
            guard let self else {
                return
            }
            self.onEditOldPassword?(self.oldPasswordTextField.currentText())
        }
        $0.setNextResponder(newPasswordTextField.responder)
        $0.validator = RequiredValidator()
        return $0
    }(DValidatableTextField())

    private lazy var newPasswordTextField: DValidatableTextField = {
        $0.configure(
            placeholder: L10n.Localizable.Profile.ChangePassword.Placeholder.newPassword,
            correction: .no,
            keyboardType: .asciiCapable,
            mode: .password
        )
        $0.onTextChange = { [weak self] text in
            guard let self else {
                return
            }
            self.onEditNewPassword?(self.newPasswordTextField.currentText())
        }
        $0.onEndEditing = { [weak self] _ in
            self?.repeatNewPasswordTextField.validator = RequiredValidator(
                MatchPasswordValidator(password: self?.newPasswordTextField.currentText() ?? "")
            )
        }
        $0.setNextResponder(repeatNewPasswordTextField.responder)
        $0.validator = RequiredValidator(PasswordValidator())
        return $0
    }(DValidatableTextField())

    private lazy var repeatNewPasswordTextField: DValidatableTextField = {
        $0.configure(
            placeholder: L10n.Localizable.Profile.ChangePassword.Placeholder.repeatNewPassword,
            correction: .no,
            keyboardType: .asciiCapable,
            mode: .password
        )
        $0.onShouldReturn = { [weak self] _ in
            self?.save()
        }
        $0.validator = RequiredValidator(MatchPasswordValidator(password: ""))
        return $0
    }(DValidatableTextField())

    private lazy var saveButton = {
        $0.title = L10n.Localizable.Profile.ChangePassword.Button.save
        $0.setAction { [weak self] in
            self?.save()
        }
        return $0
    }(DButton())

    // MARK: - Properties

    var onEditOldPassword: ((String) -> Void)?
    var onEditNewPassword: ((String) -> Void)?

    var onSave: EmptyClosure?

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - UI Setup

    private func setupUI() {
        addSubview(mainVStackView)
        mainVStackView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide).inset(Constants.insets)
        }
    }

    // MARK: - Activity

    func setSavingActivity(isLoading: Bool) {
        saveButton.setLoading(isLoading)
    }

    func save() {
        endEditing(true)
        let textFields = mainVStackView.arrangedSubviews.compactMap { $0 as? DValidatableTextField }
        if textFields.allSatisfy({ $0.isValid() }) {
            onSave?()
            return
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
        textFields.forEach { $0.isValid() }
    }

}
