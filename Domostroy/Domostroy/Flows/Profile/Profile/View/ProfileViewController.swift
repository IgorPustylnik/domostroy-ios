//
//  ProfileViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class ProfileViewController: ScrollViewController {

    // MARK: - Properties

    private lazy var editButton = {
        $0.title = L10n.Localizable.Profile.NavigationBar.Button.edit
        $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        $0.insets = .zero
        $0.setAction { [weak self] in
            self?.output?.edit()
        }
        return $0
    }(DButton(type: .plainPrimary))

    private lazy var settingsButton = {
        $0.image = .Buttons.settings.withTintColor(.Domostroy.primary, renderingMode: .alwaysOriginal)
        $0.insets = .zero
        $0.setAction { [weak self] in
            self?.output?.settings()
        }
        return $0
    }(DButton(type: .plainPrimary))

    private var profileView = ProfileView()

    private lazy var refreshControl = UIRefreshControl()

    var output: ProfileViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
    }

    override func loadView() {
        super.loadView()
        contentView = profileView
        profileView.onAdminPanel = { [weak self] in
            self?.output?.adminPanel()
        }
        profileView.onLogout = { [weak self] in
            self?.output?.logout()
        }
    }

}

// MARK: - ProfileViewInput

extension ProfileViewController: ProfileViewInput {

    func setupInitialState() {
        profileView.setupInitialState()
        setupRefreshControl()
        view.backgroundColor = .systemBackground
        navigationBar.title = L10n.Localizable.Profile.title
    }

    func configure(with viewModel: ProfileView.ViewModel) {
        profileView.configure(with: viewModel)
        navigationBar.rightItems = [editButton, settingsButton]
    }

    func endRefreshing() {
        refreshControl.endRefreshing()
    }

}

// MARK: - Private methods

private extension ProfileViewController {
    func setupRefreshControl() {
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
}

// MARK: - Selector

@objc
private extension ProfileViewController {
    func refresh() {
        output?.refresh()
    }
}
