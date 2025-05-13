//
//  IncomingRequestDetailsView.swift
//  Domostroy
//
//  Created by igorpustylnik on 13/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit

final class IncomingRequestDetailsView: UIView {

    // MARK: - ViewModel

    struct ViewModel {
        let offer: ConciseOfferView.ViewModel
        let status: RequestStatusView.Status
        let dates: String
        let submissionDate: String
        let user: User
        let actions: [Action]

        struct User {
            let username: String
            let phoneNumber: String
            let imageUrl: URL?
            let loadImage: (URL?, UIImageView) -> Void
        }

        struct Action {
            let type: DButton.ButtonType
            let title: String
            let action: EmptyClosure?
        }
    }

    // MARK: - Constants

    private enum Constants {
        static let insets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let conciseOfferViewHeight: CGFloat = 56
        static let mainVStackSpacing: CGFloat = 20
        static let infoVStackSpacing: CGFloat = 5
        static let avatarSize: CGSize = .init(width: 58, height: 58)
        static let userInfoVStackSpacing: CGFloat = 5
        static let buttonsVStackSpacing: CGFloat = 10
    }

    // MARK: - UI Elements

    private lazy var mainVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.mainVStackSpacing
        $0.addArrangedSubview(conciseOfferView)
        $0.addArrangedSubview(statusViewContainer)
        $0.addArrangedSubview(infoHeaderLabel)
        $0.addArrangedSubview(infoVStackView)
        $0.addArrangedSubview(userHStackView)
        $0.addArrangedSubview(buttonsVStackView)
        return $0
    }(UIStackView())

    private lazy var conciseOfferView = {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(openOffer))
        $0.addGestureRecognizer(tapRecognizer)
        return $0
    }(ConciseOfferView())

    private lazy var statusViewContainer = {
        $0.axis = .horizontal
        $0.addArrangedSubview(statusView)
        $0.addArrangedSubview(UIView())
        return $0
    }(UIStackView())

    private lazy var statusView = RequestStatusView()

    private lazy var infoHeaderLabel = {
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.text = L10n.Localizable.RequestDetails.Info.title
        return $0
    }(UILabel())

    private lazy var infoVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.infoVStackSpacing
        $0.addArrangedSubview(datesLabel)
        $0.addArrangedSubview(submissionDateLabel)
        return $0
    }(UIStackView())

    private lazy var datesLabel = {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        return $0
    }(UILabel())

    private lazy var submissionDateLabel = {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        return $0
    }(UILabel())

    private lazy var userHStackView = {
        $0.axis = .horizontal
        $0.addArrangedSubview(userInfoVStackView)
        $0.addArrangedSubview(userAvatarImageView)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(openUser))
        $0.addGestureRecognizer(tapRecognizer)
        return $0
    }(UIStackView())

    private lazy var userInfoVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.userInfoVStackSpacing
        $0.addArrangedSubview(usernameLabel)
        $0.addArrangedSubview(userPhoneNumberLabel)
        return $0
    }(UIStackView())

    private lazy var usernameLabel = {
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        return $0
    }(UILabel())

    private lazy var userPhoneNumberLabel = {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        return $0
    }(UILabel())

    private lazy var userAvatarImageView = {
        $0.backgroundColor = .secondarySystemBackground
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = Constants.avatarSize.width / 2
        $0.layer.masksToBounds = true
        $0.snp.makeConstraints { make in
            make.size.equalTo(Constants.avatarSize)
        }
        return $0
    }(UIImageView())

    private lazy var buttonsVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.buttonsVStackSpacing
        return $0
    }(UIStackView())

    // MARK: - Properties

    var onOpenOffer: EmptyClosure?
    var onOpenUser: EmptyClosure?

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
        backgroundColor = .systemBackground
        addSubview(mainVStackView)

        mainVStackView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide).inset(Constants.insets)
        }
    }

    // MARK: - Configuration

    func configure(with viewModel: ViewModel) {
        conciseOfferView.configure(with: viewModel.offer)
        statusView.configure(with: viewModel.status)
        datesLabel.text = viewModel.dates
        submissionDateLabel.text = viewModel.submissionDate
        usernameLabel.text = viewModel.user.username
        userPhoneNumberLabel.text = viewModel.user.phoneNumber
        viewModel.user.loadImage(viewModel.user.imageUrl, userAvatarImageView)

        buttonsVStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        viewModel.actions.forEach { action in
            buttonsVStackView.addArrangedSubview(makeButton(with: action))
        }
    }
}

// MARK: - Private methods

private extension IncomingRequestDetailsView {
    private func makeButton(with viewModel: ViewModel.Action) -> DButton {
        let button = DButton(type: viewModel.type)
        button.title = viewModel.title
        button.setAction {
            viewModel.action?()
        }
        return button
    }
}

// MARK: - Selectors

@objc
private extension IncomingRequestDetailsView {
    func openOffer() {
        onOpenOffer?()
    }

    func openUser() {
        onOpenUser?()
    }
}
