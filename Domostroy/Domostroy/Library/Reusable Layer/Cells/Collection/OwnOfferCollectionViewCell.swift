//
//  OwnOfferCollectionViewCell.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 26.04.2025.
//

import UIKit
import SnapKit
import ReactiveDataDisplayManager

final class OwnOfferCollectionViewCell: UICollectionViewCell, HighlightableScaleView {

    var highlightScaleFactor: CGFloat = 0.97

    // MARK: - ViewModel

    struct ViewModel {
        let id: Int
        let imageUrl: URL?
        let loadImage: (URL?, UIImageView) -> Void
        let title: String
        let price: String
        let description: String
        let createdAt: String
        let actions: [ActionButtonModel]

        struct ActionButtonModel {
            let image: UIImage
            let action: EmptyClosure?
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
        $0.addArrangedSubview(createdAtLabel)
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

    private lazy var createdAtLabel = {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.numberOfLines = 1
        $0.textColor = .secondaryLabel
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

extension OwnOfferCollectionViewCell: ConfigurableItem {

    func configure(with viewModel: ViewModel) {
        titleLabel.text = viewModel.title
        priceLabel.text = "\(viewModel.price)"
        descriptionLabel.text = viewModel.description
        createdAtLabel.text = viewModel.createdAt
        viewModel.loadImage(viewModel.imageUrl, itemImageView)
        viewModel.actions.map { createActionButton(with: $0) }.forEach { actionsVStack.addArrangedSubview($0) }
    }

}

// MARK: - Private methods

private extension OwnOfferCollectionViewCell {

    func createActionButton(with action: ViewModel.ActionButtonModel) -> DButton {
        let button = DButton(type: .plainPrimary)
        button.image = action.image.withTintColor(.Domostroy.primary, renderingMode: .alwaysOriginal)
        button.setAction {
            action.action?()
        }
        button.insets = .zero
        return button
    }

}

// MARK: - Equatable ViewModel

extension OwnOfferCollectionViewCell.ViewModel: Equatable {
    static func ==(
        lhs: OwnOfferCollectionViewCell.ViewModel,
        rhs: OwnOfferCollectionViewCell.ViewModel
    ) -> Bool {
        return lhs.imageUrl == rhs.imageUrl &&
               lhs.title == rhs.title &&
               lhs.price == rhs.price &&
               lhs.description == rhs.description &&
               lhs.createdAt == rhs.createdAt &&
               lhs.actions == rhs.actions
    }
}

extension OwnOfferCollectionViewCell.ViewModel.ActionButtonModel: Equatable {
    static func ==(
        lhs: OwnOfferCollectionViewCell.ViewModel.ActionButtonModel,
        rhs: OwnOfferCollectionViewCell.ViewModel.ActionButtonModel
    ) -> Bool {
        return lhs.image == rhs.image
    }
}
