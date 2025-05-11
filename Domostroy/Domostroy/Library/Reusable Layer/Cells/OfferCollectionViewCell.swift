//
//  OfferCollectionViewCell.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 07.04.2025.
//

import UIKit
import SnapKit
import ReactiveDataDisplayManager

final class OfferCollectionViewCell: UICollectionViewCell, HighlightableScaleView {

    var highlightScaleFactor: CGFloat = 0.97

    typealias Model = ViewModel

    // MARK: - ViewModel

    struct ViewModel {
        let id: Int
        let imageUrl: URL?
        let loadImage: (URL?, UIImageView) -> Void
        let title: String
        let price: String
        let location: String
        let actions: [ActionButtonModel]
        let toggleActions: [ToggleButtonModel]

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
        static let mainVStackSpacing: CGFloat = 10
        static let infoVStackSpacing: CGFloat = 5
        static let imageViewCornerRadius: CGFloat = 8
        static let actionsVStackViewSpacing: CGFloat = 8
        static let actionSize: CGSize = .init(width: 22, height: 22)
        static let bottomHStackSpacing: CGFloat = 5

        static let titleFont: UIFont = .systemFont(ofSize: 14, weight: .regular)
        static let priceFont: UIFont = .systemFont(ofSize: 14, weight: .semibold)
        static let locationFont: UIFont = .systemFont(ofSize: 12, weight: .regular)
    }

    // MARK: - UI Elements

    private lazy var mainVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.mainVStackSpacing
        $0.addArrangedSubview(itemImageView)
        $0.addArrangedSubview(bottomHStackView)
        return $0
    }(UIStackView())

    private lazy var itemImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = Constants.imageViewCornerRadius
        $0.layer.masksToBounds = true
        $0.backgroundColor = .secondarySystemBackground
        return $0
    }(UIImageView())

    private lazy var bottomHStackView = {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.spacing = Constants.bottomHStackSpacing
        $0.addArrangedSubview(infoVStackView)
        $0.addArrangedSubview(actionsVStackView)
        return $0
    }(UIStackView())

    private lazy var infoVStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.infoVStackSpacing
        $0.addArrangedSubview(titleLabel)
        $0.addArrangedSubview(priceLabel)
        $0.addArrangedSubview(locationLabel)
        return $0
    }(UIStackView())

    private lazy var titleLabel: UILabel = {
        $0.font = Constants.titleFont
        $0.numberOfLines = 2
        return $0
    }(UILabel())

    private lazy var priceLabel: UILabel = {
        $0.font = Constants.priceFont
        $0.numberOfLines = 1
        return $0
    }(UILabel())

    private lazy var locationLabel: UILabel = {
        $0.font = Constants.locationFont
        $0.textColor = .secondaryLabel
        $0.numberOfLines = 1
        return $0
    }(UILabel())

    private lazy var actionsVStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.actionsVStackViewSpacing
        $0.snp.makeConstraints { make in
            make.width.equalTo(Constants.actionSize.width)
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
        locationLabel.text = nil
        actionsVStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    // MARK: - Setup UI

    private func setupUI() {
        backgroundColor = .systemBackground
        addSubview(mainVStackView)
        mainVStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().priority(.high)
        }
        itemImageView.snp.makeConstraints { make in
            make.height.equalTo(snp.width)
        }
    }
}

// MARK: - ConfigurableItem

extension OfferCollectionViewCell: ConfigurableItem {

    func configure(with viewModel: ViewModel) {
        titleLabel.text = viewModel.title
        priceLabel.text = "\(viewModel.price)"
        locationLabel.text = viewModel.location
        viewModel.loadImage(viewModel.imageUrl, itemImageView)
        viewModel.actions.map { createActionButton(with: $0) }.forEach { actionsVStackView.addArrangedSubview($0) }
        viewModel.toggleActions.map { createToggleButton(with: $0) }.forEach { actionsVStackView.addArrangedSubview($0) }
    }

}

// MARK: - Private methods

private extension OfferCollectionViewCell {

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

extension OfferCollectionViewCell.ViewModel: Equatable {
    static func ==(lhs: OfferCollectionViewCell.ViewModel, rhs: OfferCollectionViewCell.ViewModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.imageUrl == rhs.imageUrl &&
               lhs.title == rhs.title &&
               lhs.price == rhs.price &&
               lhs.location == rhs.location &&
               lhs.actions == rhs.actions &&
               lhs.toggleActions == rhs.toggleActions
    }
}

extension OfferCollectionViewCell.ViewModel.ActionButtonModel: Equatable {
    static func ==(
        lhs: OfferCollectionViewCell.ViewModel.ActionButtonModel,
        rhs: OfferCollectionViewCell.ViewModel.ActionButtonModel
    ) -> Bool {
        return lhs.image == rhs.image
    }
}

extension OfferCollectionViewCell.ViewModel.ToggleButtonModel: Equatable {
    static func ==(
        lhs: OfferCollectionViewCell.ViewModel.ToggleButtonModel,
        rhs: OfferCollectionViewCell.ViewModel.ToggleButtonModel
    ) -> Bool {
        return lhs.initialState == rhs.initialState &&
               lhs.onImage == rhs.onImage &&
               lhs.offImage == rhs.offImage
    }
}
