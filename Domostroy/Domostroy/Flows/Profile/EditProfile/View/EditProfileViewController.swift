//
//  EditProfileViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 14/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class EditProfileViewController: ScrollViewController {

    // MARK: - UI Elements

    private lazy var saveButton = {
        $0.title = L10n.Localizable.Profile.Edit.NavigationBar.Button.save
        $0.insets = .zero
        $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        $0.setAction { [weak self] in
            self?.editProfileView.save()
        }
        return $0
    }(DButton(type: .plainPrimary))

    private var editProfileView = {
        $0.isHidden = true
        return $0
    }(EditProfileView())

    // MARK: - Properties

    var output: EditProfileViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
    }

    override func loadView() {
        super.loadView()
        contentView = editProfileView
        editProfileView.onEditFirstName = { [weak self] text in
            self?.output?.firstNameChanged(text)
        }
        editProfileView.onEditLastName = { [weak self] text in
            self?.output?.lastNameChanged(text)
        }
        editProfileView.onEditPhoneNumber = { [weak self] text in
            self?.output?.phoneNumberChanged(text)
        }
        editProfileView.onChangePassword = { [weak self] in
            self?.output?.showChangePassword()
        }
        editProfileView.onSave = { [weak self] in
            self?.output?.save()
        }
    }

}

// MARK: - EditProfileViewInput

extension EditProfileViewController: EditProfileViewInput {

    func setupInitialState() {
        editProfileView.isHidden = false
        navigationBar.title = L10n.Localizable.Profile.Edit.title
        navigationBar.rightItems = [saveButton]
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
    }

    func configure(with viewModel: EditProfileView.ViewModel) {
        editProfileView.configure(with: viewModel)
    }

    func setSavingActivity(isLoading: Bool) {
        saveButton.setLoading(isLoading)
    }

}
