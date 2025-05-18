//
//  ProfileView.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit

final class ProfileView: UIView {

    // MARK: - ViewModel

    struct ViewModel {
        let imageUrl: URL?
        let loadImage: (URL?, UIImageView) -> Void
        let name: String
        let phoneNumber: String
        let email: String
        let isAdmin: Bool
    }

    // MARK: - Constants

    private enum Constants {
        static let insets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let avatarSize: CGSize = .init(width: 100, height: 100)
        static let mainVStackSpacing: CGFloat = 16
        static let infoVStackSpacing: CGFloat = 10
    }

    // MARK: - UI Elements

    private lazy var mainVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.mainVStackSpacing
        $0.addArrangedSubview(avatarContainerView)
        $0.addArrangedSubview(infoVStackView)
        $0.addArrangedSubview(adminButton)
        $0.addArrangedSubview(logoutButton)
        return $0
    }(UIStackView())

    private lazy var avatarContainerView = {
        $0.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        $0.isHidden = true
        return $0
    }(UIView())

    private lazy var avatarImageView = {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = Constants.avatarSize.width / 2
        $0.layer.masksToBounds = true
        $0.snp.makeConstraints { make in
            make.size.equalTo(Constants.avatarSize)
        }
        return $0
    }(UIImageView())

    private lazy var infoVStackView = {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = Constants.infoVStackSpacing
        $0.addArrangedSubview(nameLabel)
        $0.addArrangedSubview(phoneNumberLabel)
        $0.addArrangedSubview(emailLabel)
        $0.isHidden = true
        return $0
    }(UIStackView())

    private lazy var nameLabel = {
        $0.font = .systemFont(ofSize: 24, weight: .semibold)
        return $0
    }(UILabel())

    private lazy var phoneNumberLabel = {
        $0.font = .systemFont(ofSize: 16, weight: .light)
        return $0
    }(UILabel())

    private lazy var emailLabel = {
        $0.font = .systemFont(ofSize: 16, weight: .light)
        return $0
    }(UILabel())

    private lazy var adminButton = {
        $0.title = L10n.Localizable.Profile.Button.AdminPanel.title
        $0.setAction { [weak self] in
            self?.onAdminPanel?()
        }
        $0.isHidden = true
        return $0
    }(DButton(type: .filledSecondary))

    private lazy var logoutButton = {
        $0.title = L10n.Localizable.Profile.Button.Logout.title
        $0.setAction { [weak self] in
            self?.onLogout?()
        }
        return $0
    }(DButton(type: .destructive))

    // MARK: - Properties

    var onAdminPanel: EmptyClosure?
    var onLogout: EmptyClosure?

    // MARK: - Configuration

    func setupInitialState() {
        addSubview(mainVStackView)
        mainVStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.insets)
        }
    }

    func configure(with viewModel: ViewModel) {
        viewModel.loadImage(viewModel.imageUrl, avatarImageView)
        nameLabel.text = viewModel.name
        phoneNumberLabel.text = viewModel.phoneNumber
        emailLabel.text = viewModel.email
        adminButton.isHidden = !viewModel.isAdmin
        avatarContainerView.isHidden = false
        infoVStackView.isHidden = false
    }

}
