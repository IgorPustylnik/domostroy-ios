//
//  ProfileBannedViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 04/06/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit

final class ProfileBannedViewController: ScrollViewController {

    // MARK: - Constants

    private enum Constants {
        static let insets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let mainVStackSpacing: CGFloat = 30
    }

    // MARK: - UI Elements

    private lazy var mainVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.mainVStackSpacing
        return $0
    }(UIStackView(arrangedSubviews: [
        noSignImageView, titleLabel, messageLabel, bannedButton
    ]))

    private lazy var noSignImageView = {
        $0.contentMode = .scaleAspectFit
        $0.image = .Banned.nosign.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        return $0
    }(UIImageView())

    private lazy var titleLabel = {
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.text = L10n.Localizable.Profile.Banned.title
        $0.textAlignment = .center
        return $0
    }(UILabel())

    private lazy var messageLabel = {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.text = L10n.Localizable.Profile.Banned.message
        $0.textAlignment = .center
        return $0
    }(UILabel())

    private lazy var bannedButton = {
        $0.title = L10n.Localizable.Profile.Button.Logout.title
        $0.setAction { [weak self] in
            self?.output?.logout()
        }
        return $0
    }(DButton(type: .destructive))

    private lazy var refreshControl = UIRefreshControl()

    // MARK: - Properties

    var output: ProfileBannedViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
    }

}

// MARK: - ProfileBannedViewInput

extension ProfileBannedViewController: ProfileBannedViewInput {

    func setupInitialState() {
        hidesTabBar = true
        navigationBar.isHidden = true
        setupRefreshControl()
        view.backgroundColor = .systemBackground
        scrollView.alwaysBounceVertical = true
        contentView.addSubview(mainVStackView)
        contentView.snp.makeConstraints { make in
            make.height.equalTo(view.safeAreaLayoutGuide)
        }
        mainVStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(Constants.insets)
        }
    }

    func endRefreshing() {
        refreshControl.endRefreshing()
    }

}

// MARK: - Private methods

private extension ProfileBannedViewController {
    func setupRefreshControl() {
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
}

// MARK: - Selector

@objc
private extension ProfileBannedViewController {
    func refresh() {
        output?.refresh()
    }
}
