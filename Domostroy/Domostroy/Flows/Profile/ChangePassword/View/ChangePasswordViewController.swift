//
//  ChangePasswordViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 14/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class ChangePasswordViewController: ScrollViewController {

    // MARK: - Properties

    private var changePasswordView = ChangePasswordView()

    var output: ChangePasswordViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
    }

    override func loadView() {
        super.loadView()
        contentView = changePasswordView
        changePasswordView.onEditOldPassword = { [weak self] text in
            self?.output?.oldPasswordChanged(text)
        }
        changePasswordView.onEditNewPassword = { [weak self] text in
            self?.output?.newPasswordChanged(text)
        }
        changePasswordView.onSave = { [weak self] in
            self?.output?.save()
        }
    }
}

// MARK: - ChangePasswordViewInput

extension ChangePasswordViewController: ChangePasswordViewInput {

    func setupInitialState() {
        navigationBar.title = L10n.Localizable.Profile.ChangePassword.title
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
    }

    func setSavingActivity(isLoading: Bool) {
        changePasswordView.setSavingActivity(isLoading: isLoading)
    }

}
