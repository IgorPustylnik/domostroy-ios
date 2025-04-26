//
//  FavoriteOfferCollectionViewCell.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 26.04.2025.
//

import UIKit
import SnapKit
import ReactiveDataDisplayManager

final class FavoriteOfferCollectionViewCell: UICollectionViewCell, HighlightableScaleView {

    var highlightScaleFactor: CGFloat = 0.97

    typealias Model = ViewModel

    // MARK: - ViewModel

    struct ViewModel {
        let id: Int
        let imageUrl: URL?
        let loadImage: (URL?, UIImageView) -> Void
        let title: String
        let price: String
        let description: String
        let user: UserViewModel
        let actions: [ActionButtonModel]
        let toggleActions: [ToggleButtonModel]

        struct UserViewModel {
            let id: Int
            let loadUser: (Int, UIImageView, UILabel) -> Void
        }

        struct ActionButtonModel {
            let image: UIImage
            let action: EmptyClosure?
        }

        struct ToggleButtonModel {
            let initialState: Bool
            let onImage: UIImage
            let offImage: UIImage
            let toggleAction: ToggleAction?
        }
    }

    // MARK: - Constants

    private enum Constants {
        static let mainHStackSpacing: CGFloat = 16
        static let imageViewSize: CGSize = .init(width: 100, height: 84)
        static let imageViewCornerRadius: CGFloat = 8
        static let infoVStackSpacing: CGFloat = 5
        static let userHStackViewSpacing: CGFloat = 8
        static let userImageViewSize: CGSize = .init(width: 20, height: 20)
        static let actionsVStackViewSpacing: CGFloat = 8
        static let actionSize: CGSize = .init(width: 22, height: 22)
    }

    // MARK: - UI Elements

    private lazy var mainHStackView = {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.spacing = Constants.mainHStackSpacing
        $0.addArrangedSubview(itemImageView)
        $0.addArrangedSubview(infoVStackView)
        $0.addArrangedSubview(actionsVStack)
        return $0
    }(UIStackView())

    private lazy var itemImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = Constants.imageViewCornerRadius
        $0.layer.masksToBounds = true
        $0.backgroundColor = .secondarySystemBackground
        $0.snp.makeConstraints { make in
            make.size.equalTo(Constants.imageViewSize)
        }
        return $0
    }(UIImageView())

    private lazy var infoVStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.infoVStackSpacing
        $0.addArrangedSubview(titleLabel)
        $0.addArrangedSubview(priceLabel)
        $0.addArrangedSubview(descriptionLabel)
        $0.addArrangedSubview(userHStackView)
        return $0
    }(UIStackView())

    private lazy var titleLabel: UILabel = {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.numberOfLines = 2
        return $0
    }(UILabel())

    private lazy var priceLabel: UILabel = {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.numberOfLines = 1
        return $0
    }(UILabel())

    private lazy var descriptionLabel: UILabel = {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.numberOfLines = 2
        return $0
    }(UILabel())

    private lazy var userHStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = Constants.userHStackViewSpacing
        $0.addArrangedSubview(userImageView)
        $0.addArrangedSubview(userNameLabel)
        return $0
    }(UIStackView())

    private lazy var userImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.snp.makeConstraints { make in
            make.size.equalTo(Constants.userImageViewSize.width)
        }
        $0.layer.cornerRadius = Constants.userImageViewSize.width / 2
        $0.layer.masksToBounds = true
        return $0
    }(UIImageView())

    private lazy var userNameLabel: UILabel = {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 1
        return $0
    }(UILabel())

    private lazy var actionsVStack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.actionsVStackViewSpacing
        $0.snp.makeConstraints { make in
            make.width.equalTo(Constants.actionSize)
        }
        return $0
    }(UIStackView())

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        descriptionLabel.text = nil
        userImageView.image = nil
        userNameLabel.text = nil
        actionsVStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    // MARK: - Setup UI

    private func setupUI() {
        backgroundColor = .systemBackground
        addSubview(mainHStackView)

        mainHStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview().priority(.high)
        }
    }
}

// MARK: - ConfigurableItem

extension FavoriteOfferCollectionViewCell: ConfigurableItem {

    func configure(with viewModel: ViewModel) {
        titleLabel.text = viewModel.title
        priceLabel.text = "\(viewModel.price)"
        descriptionLabel.text = viewModel.description
        viewModel.loadImage(viewModel.imageUrl, itemImageView)
        viewModel.user.loadUser(viewModel.user.id, userImageView, userNameLabel)
        viewModel.actions.map { createActionButton(with: $0) }.forEach { actionsVStack.addArrangedSubview($0) }
        viewModel.toggleActions.map { createToggleButton(with: $0) }.forEach { actionsVStack.addArrangedSubview($0) }
    }

}

// MARK: - Private methods

private extension FavoriteOfferCollectionViewCell {

    func createActionButton(with action: ViewModel.ActionButtonModel) -> DButton {
        let button = DButton(type: .plainPrimary)
        button.image = action.image.withTintColor(.Domostroy.primary, renderingMode: .alwaysOriginal)
        button.setAction {
            action.action?()
        }
        button.insets = .zero
        return button
    }

    func createToggleButton(with toggle: ViewModel.ToggleButtonModel) -> DToggleButton {
        let button = DToggleButton(type: .plainPrimary)
        button.configure(
            initialState: toggle.initialState,
            onImage: toggle.onImage.withTintColor(.Domostroy.primary, renderingMode: .alwaysOriginal),
            offImage: toggle.offImage.withTintColor(.Domostroy.primary, renderingMode: .alwaysOriginal),
            toggleAction: toggle.toggleAction
        )
        button.insets = .zero
        button.imageSize = Constants.actionSize
        return button
    }

}

// MARK: - Equatable ViewModel

extension FavoriteOfferCollectionViewCell.ViewModel: Equatable {
    static func ==(
        lhs: FavoriteOfferCollectionViewCell.ViewModel,
        rhs: FavoriteOfferCollectionViewCell.ViewModel
    ) -> Bool {
        return lhs.imageUrl == rhs.imageUrl &&
               lhs.title == rhs.title &&
               lhs.price == rhs.price &&
               lhs.description == rhs.description &&
               lhs.user == rhs.user &&
               lhs.actions == rhs.actions &&
               lhs.toggleActions == rhs.toggleActions
    }
}

extension FavoriteOfferCollectionViewCell.ViewModel.UserViewModel: Equatable {
    static func ==(
        lhs: FavoriteOfferCollectionViewCell.ViewModel.UserViewModel,
        rhs: FavoriteOfferCollectionViewCell.ViewModel.UserViewModel
    ) -> Bool {
        return lhs.id == rhs.id
    }
}

extension FavoriteOfferCollectionViewCell.ViewModel.ActionButtonModel: Equatable {
    static func ==(
        lhs: FavoriteOfferCollectionViewCell.ViewModel.ActionButtonModel,
        rhs: FavoriteOfferCollectionViewCell.ViewModel.ActionButtonModel
    ) -> Bool {
        return lhs.image == rhs.image
    }
}

extension FavoriteOfferCollectionViewCell.ViewModel.ToggleButtonModel: Equatable {
    static func ==(
        lhs: FavoriteOfferCollectionViewCell.ViewModel.ToggleButtonModel,
        rhs: FavoriteOfferCollectionViewCell.ViewModel.ToggleButtonModel
    ) -> Bool {
        return lhs.initialState == rhs.initialState &&
               lhs.onImage == rhs.onImage &&
               lhs.offImage == rhs.offImage
    }
}
