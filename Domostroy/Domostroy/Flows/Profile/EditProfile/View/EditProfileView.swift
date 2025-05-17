//
//  EditProfileView.swift
//  Domostroy
//
//  Created by igorpustylnik on 14/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit

final class EditProfileView: UIView {

    // MARK: - ViewModel

    struct ViewModel {
        let avatarUrl: URL?
        let loadAvatar: (URL?, UIImageView) -> Void
        let firstName: String
        let lastName: String
        let phoneNumber: String
    }

    // MARK: - Constants

    private enum Constants {
        static let insets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let mainVStackSpacing: CGFloat = 16
        static let avatarSize: CGSize = .init(width: 100, height: 100)
    }

    // MARK: - UI Elements

    private lazy var mainVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.mainVStackSpacing
        $0.addArrangedSubview(avatarContainerView)
        $0.addArrangedSubview(firstNameTextField)
        $0.addArrangedSubview(lastNameTextField)
        $0.addArrangedSubview(phoneNumberTextField)
        $0.addArrangedSubview(changePasswordButton)
        return $0
    }(UIStackView())

    private lazy var avatarContainerView = {
        $0.axis = .horizontal
        $0.distribution = .equalCentering
        $0.addArrangedSubview(UIView())
        $0.addArrangedSubview(avatarImageView)
        $0.addArrangedSubview(UIView())
        return $0
    }(UIStackView())

    private lazy var avatarImageView = {
        $0.backgroundColor = .secondarySystemBackground
        $0.layer.cornerRadius = Constants.avatarSize.width / 2
        $0.layer.masksToBounds = true
        $0.snp.makeConstraints { make in
            make.size.equalTo(Constants.avatarSize)
        }
        return $0
    }(UIImageView())

    private lazy var firstNameTextField: DValidatableTextField = {
        $0.configure(
            placeholder: L10n.Localizable.Profile.Edit.Placeholder.firstName,
            correction: .no,
            keyboardType: .default,
            mode: .firstName
        )
        $0.onTextChange = { [weak self] _ in
            guard let self else {
                return
            }
            self.onEditFirstName?(self.firstNameTextField.currentText())
        }
        $0.setNextResponder(lastNameTextField.responder)
        $0.validator = RequiredValidator(UsernameValidator())
        return $0
    }(DValidatableTextField())

    private lazy var lastNameTextField: DValidatableTextField = {
        $0.configure(
            placeholder: L10n.Localizable.Profile.Edit.Placeholder.lastName,
            correction: .no,
            keyboardType: .default,
            mode: .lastName
        )
        $0.onTextChange = { [weak self] _ in
            guard let self else {
                return
            }
            self.onEditLastName?(self.lastNameTextField.currentText())
        }
        $0.setNextResponder(phoneNumberTextField.responder)
        $0.validator = OptionalValidator(UsernameValidator())
        return $0
    }(DValidatableTextField())

    private lazy var phoneNumberTextField: DValidatableTextField = {
        $0.configure(
            placeholder: L10n.Localizable.Profile.Edit.Placeholder.phoneNumber,
            correction: .no,
            keyboardType: .phonePad,
            mode: .phoneNumber
        )
        $0.onTextChange = { [weak self] _ in
            guard let self else {
                return
            }
            self.onEditPhoneNumber?(self.phoneNumberTextField.currentText())
        }
        $0.onShouldReturn = { textField in
            textField.resignFirstResponder()
        }
        $0.validator = RequiredValidator(RussianPhoneValidator())
        $0.formatter = RussianPhoneTextFieldFormatter()
        return $0
    }(DValidatableTextField())

    private lazy var changePasswordButton = {
        $0.title = L10n.Localizable.Profile.Edit.Button.changePassword
        $0.setAction { [weak self] in
            self?.onChangePassword?()
        }
        return $0
    }(DButton(type: .filledSecondary))

    // MARK: - Properties

    var onEditFirstName: ((String) -> Void)?
    var onEditLastName: ((String) -> Void)?
    var onEditPhoneNumber: ((String) -> Void)?

    var onChangePassword: EmptyClosure?
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

    // MARK: - Configuration

    func configure(with viewModel: ViewModel) {
        viewModel.loadAvatar(viewModel.avatarUrl, avatarImageView)
        firstNameTextField.setText(viewModel.firstName)
        lastNameTextField.setText(viewModel.lastName)
        phoneNumberTextField.setText(viewModel.phoneNumber)
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
