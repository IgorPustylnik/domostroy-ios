//
//  OfferDetailsView.swift
//  Domostroy
//
//  Created by igorpustylnik on 10/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit

final class OfferDetailsView: UIView {

    // MARK: - ViewModel

    struct ViewModel {
        let price: String
        let title: String
        let loadCity: (UILabel) -> Void
        let loadInfo: (@escaping ([(String, String)]) -> Void) -> Void
        let description: String
        let publishedAt: String
        let user: User
        let isBanned: Bool
        let banReason: String?
        let onRent: EmptyClosure?

        struct User {
            let url: URL?
            let loadUser: (URL?, View) -> Void
            let onOpenProfile: EmptyClosure

            struct View {
                let nameLabel: UILabel
                let infoLabel: UILabel
                let avatarImageView: UIImageView
            }
        }
    }

    // MARK: - Constants

    private enum Constants {
        static let mainVStackSpacing: CGFloat = 20
        static let topVStackSpacing: CGFloat = 10
        static let headerVStackSpacing: CGFloat = 5
        static let stackHeaderBottomPadding: CGFloat = 10
        static let infoDetailsVStackSpacing: CGFloat = 3
        static let avatarSize: CGSize = .init(width: 58, height: 58)
    }

    // MARK: - Properties

    private var onOpenProfile: EmptyClosure?
    private var onRent: EmptyClosure?

    // MARK: - UI Elements

    private lazy var mainVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.mainVStackSpacing
        $0.addArrangedSubview(headerVStackView)
        $0.addArrangedSubview(infoVStack)
        $0.addArrangedSubview(descriptionVStack)
        $0.addArrangedSubview(userHStackView)
        $0.addArrangedSubview(publishedAtLabel)
        return $0
    }(UIStackView())

    // MARK: - Header

    private lazy var headerVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.topVStackSpacing
        $0.addArrangedSubview(titleVStackView)
        $0.addArrangedSubview(cityLabel)
        $0.addArrangedSubview(banLabel)
        $0.addArrangedSubview(rentButton)
        return $0
    }(UIStackView())

    private lazy var titleVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.headerVStackSpacing
        $0.addArrangedSubview(priceLabel)
        $0.addArrangedSubview(titleLabel)
        return $0
    }(UIStackView())

    private lazy var priceLabel = {
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        return $0
    }(UILabel())

    private lazy var titleLabel = {
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private lazy var cityLabel = {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private lazy var banLabel = {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.numberOfLines = 0
        $0.textColor = .systemRed
        return $0
    }(UILabel())

    private lazy var rentButton = {
        $0.title = L10n.Localizable.OfferDetails.Button.rent
        $0.setAction { [weak self] in
            self?.onRent?()
        }
        return $0
    }(DButton())

    // MARK: - Info

    private lazy var infoVStack = {
        $0.axis = .vertical
        $0.spacing = Constants.stackHeaderBottomPadding
        $0.addArrangedSubview(infoHeaderLabel)
        $0.addArrangedSubview(infoDetailsVStack)
        return $0
    }(UIStackView())

    private lazy var infoHeaderLabel = {
        $0.text = L10n.Localizable.OfferDetails.Info.header
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private lazy var infoDetailsVStack = {
        $0.axis = .vertical
        $0.spacing = Constants.infoDetailsVStackSpacing
        return $0
    }(UIStackView())

    // MARK: - Description

    private lazy var descriptionVStack = {
        $0.axis = .vertical
        $0.spacing = Constants.stackHeaderBottomPadding
        $0.addArrangedSubview(descriptionHeaderLabel)
        $0.addArrangedSubview(descriptionLabel)
        return $0
    }(UIStackView())

    private lazy var descriptionHeaderLabel = {
        $0.text = L10n.Localizable.OfferDetails.Description.header
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private lazy var descriptionLabel = {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    // MARK: - User

    private lazy var userHStackView = {
        $0.axis = .horizontal
        $0.addArrangedSubview(userInfoVStackView)
        $0.addArrangedSubview(userAvatarImageView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pressedOnUser))
        $0.addGestureRecognizer(tapGesture)
        return $0
    }(UIStackView())

    private lazy var userInfoVStackView = {
        $0.axis = .vertical
        $0.addArrangedSubview(userNameLabel)
        $0.addArrangedSubview(userInfoLabel)
        return $0
    }(UIStackView())

    private lazy var userNameLabel = {
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        return $0
    }(UILabel())

    private lazy var userInfoLabel = {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        return $0
    }(UILabel())

    private lazy var userAvatarImageView = {
        $0.backgroundColor = .secondarySystemBackground
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = Constants.avatarSize.height / 2
        $0.snp.makeConstraints { make in
            make.size.equalTo(Constants.avatarSize)
        }
        $0.layer.masksToBounds = true
        return $0
    }(UIImageView())

    private lazy var publishedAtLabel = {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .secondaryLabel
        return $0
    }(UILabel())

    // MARK: - Initial state

    func setupInitialState() {
        addSubview(mainVStackView)
        mainVStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Configuration

    func configure(with viewModel: ViewModel) {
        priceLabel.text = viewModel.price
        titleLabel.text = viewModel.title
        viewModel.loadCity(cityLabel)
        viewModel.loadInfo { [weak self] completion in
            guard let self else {
                return
            }
            infoDetailsVStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
            completion.forEach {
                self.infoDetailsVStack.addArrangedSubview(self.createSpecLabel(title: $0.0, value: $0.1))
            }
        }
        if viewModel.isBanned {
            if let banReason = viewModel.banReason {
                banLabel.text = L10n.Localizable.OfferDetails.bannedFor(banReason)
            } else {
                banLabel.text = L10n.Localizable.OfferDetails.banned
            }
        } else {
            banLabel.text = nil
        }
        rentButton.isHidden = viewModel.isBanned
        descriptionLabel.text = viewModel.description
        viewModel.user.loadUser(
            viewModel.user.url,
            .init(nameLabel: userNameLabel, infoLabel: userInfoLabel, avatarImageView: userAvatarImageView)
        )
        publishedAtLabel.text = viewModel.publishedAt
        onOpenProfile = viewModel.user.onOpenProfile
        onRent = viewModel.onRent
    }

}

// MARK: - Private methods

private extension OfferDetailsView {

    func createSpecLabel(title: String, value: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)

        let text = "\(title): \(value)"
        let attributedText = NSMutableAttributedString(string: text)
        let titleRange = (text as NSString).range(of: title)
        attributedText.addAttribute(.foregroundColor, value: UIColor.secondaryLabel, range: titleRange)
        label.attributedText = attributedText

        return label
    }

}

// MARK: - Selectors

private extension OfferDetailsView {

    @objc
    func pressedOnUser() {
        onOpenProfile?()
    }

}
