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

    typealias UserView = (name: UILabel, infoLabel: UILabel, avatar: UIImageView)

    struct ViewModel {
        let price: String
        let title: String
        let city: String
        let specs: [(String, String)]
        let description: String
        let user: UserViewModel
        let onRent: EmptyClosure?

        struct UserViewModel {
            let url: URL?
            let loadUser: (URL?, UserView) -> Void
            let onOpenProfile: EmptyClosure
        }
    }

    // MARK: - Constants

    private enum Constants {
        static let mainVStackSpacing: CGFloat = 20
        static let topVStackSpacing: CGFloat = 10
        static let headerVStackSpacing: CGFloat = 5
        static let stackHeaderBottomPadding: CGFloat = 10
        static let specsDetailsVStackSpacing: CGFloat = 3
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
        $0.addArrangedSubview(specsVStack)
        $0.addArrangedSubview(descriptionVStack)
        $0.addArrangedSubview(userHStackView)
        return $0
    }(UIStackView())

    // MARK: - Header

    private lazy var headerVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.topVStackSpacing
        $0.addArrangedSubview(titleVStackView)
        $0.addArrangedSubview(cityLabel)
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

    private lazy var rentButton = {
        $0.title = L10n.Localizable.OfferDetails.Button.rent
        $0.setAction { [weak self] in
            self?.onRent?()
        }
        return $0
    }(DButton())

    // MARK: - Specs

    private lazy var specsVStack = {
        $0.axis = .vertical
        $0.spacing = Constants.stackHeaderBottomPadding
        $0.addArrangedSubview(specsHeaderLabel)
        $0.addArrangedSubview(specsDetailsVStack)
        return $0
    }(UIStackView())

    private lazy var specsHeaderLabel = {
        $0.text = L10n.Localizable.OfferDetails.Specifications.header
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private lazy var specsDetailsVStack = {
        $0.axis = .vertical
        $0.spacing = Constants.specsDetailsVStackSpacing
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
        cityLabel.text = viewModel.city
        viewModel.specs.forEach { specsDetailsVStack.addArrangedSubview(createSpecLabel(title: $0.0, value: $0.1)) }
        descriptionLabel.text = viewModel.description
        viewModel.user.loadUser(viewModel.user.url, (userNameLabel, userInfoLabel, userAvatarImageView))
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
