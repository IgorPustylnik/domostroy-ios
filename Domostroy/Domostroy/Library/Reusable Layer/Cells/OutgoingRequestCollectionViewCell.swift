//
//  OutgoingRequestCollectionViewCell.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 11.05.2025.
//

import UIKit
import SnapKit
import ReactiveDataDisplayManager

final class OutgoingRequestCollectionViewCell: UICollectionViewCell, HighlightableScaleView {

    var highlightScaleFactor: CGFloat = 0.97

    typealias Model = ViewModel

    // MARK: - ViewModel

    struct ViewModel {
        let id: Int
        let imageUrl: URL?
        let loadImage: (URL?, UIImageView) -> Void
        let title: String
        let price: String
        let dates: String
        let leaser: String
        let location: String
        let status: RequestStatus
        let actions: [Action]

        struct Action {
            let type: DButton.ButtonType
            let image: UIImage?
            let title: String
            let action: EmptyClosure?
        }
    }

    // MARK: - Constants

    private enum Constants {
        static let imageViewCornerRadius: CGFloat = 8
        static let imageViewSize: CGSize = .init(width: 100, height: 84)
        static let mainHStackSpacing: CGFloat = 16
        static let rightVStackSpacing: CGFloat = 6
        static let badgeImageSize: CGSize = .init(width: 20, height: 20)
        static let badgeBorderWidth: CGFloat = 2
        static let badgeVOffset: CGFloat = 4
        static let badgeBorderColor: UIColor = .systemBackground
        static let actionsHStackSpacing: CGFloat = 8
        static let buttonHeight: CGFloat = 32
        static let buttonCornerRadius: CGFloat = 10
    }

    // MARK: - UI Elements

    private lazy var mainHStackView = {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.spacing = Constants.mainHStackSpacing
        $0.addArrangedSubview(itemImageView)
        $0.addArrangedSubview(rightVStackView)
        return $0
    }(UIStackView())

    private lazy var itemImageView = {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = Constants.imageViewCornerRadius
        $0.layer.masksToBounds = true
        $0.backgroundColor = .secondarySystemBackground
        $0.snp.makeConstraints { make in
            make.size.equalTo(Constants.imageViewSize)
        }
        return $0
    }(UIImageView())

    private lazy var badgeImageView = {
        $0.layer.cornerRadius = Constants.badgeImageSize.width / 2
        $0.layer.borderColor = Constants.badgeBorderColor.cgColor
        $0.layer.borderWidth = Constants.badgeBorderWidth
        $0.layer.masksToBounds = true
        $0.snp.makeConstraints { make in
            make.size.equalTo(Constants.badgeImageSize)
        }
        return $0
    }(UIImageView())

    private lazy var rightVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.rightVStackSpacing
        $0.addArrangedSubview(titleLabel)
        $0.addArrangedSubview(priceLabel)
        $0.addArrangedSubview(datesLabel)
        $0.addArrangedSubview(locationLabel)
        $0.addArrangedSubview(leaserLabel)
        return $0
    }(UIStackView())

    private lazy var titleLabel = {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.numberOfLines = 2
        return $0
    }(UILabel())

    private lazy var priceLabel = {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 1
        return $0
    }(UILabel())

    private lazy var datesLabel = {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 2
        return $0
    }(UILabel())

    private lazy var locationLabel = {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 2
        return $0
    }(UILabel())

    private lazy var leaserLabel = {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 2
        return $0
    }(UILabel())

    private lazy var actionsHStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = Constants.actionsHStackSpacing
        return $0
    }(UIStackView())

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        trackTraitChanges()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        priceLabel.text = nil
        datesLabel.text = nil
        locationLabel.text = nil
        leaserLabel.text = nil
        itemImageView.image = nil
        badgeImageView.image = nil
        actionsHStackView.removeFromSuperview()
        actionsHStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    // MARK: - Setup UI

    private func setupUI() {
        backgroundColor = .systemBackground
        addSubview(mainHStackView)
        mainHStackView.addSubview(badgeImageView)
        mainHStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().priority(.high)
        }
        badgeImageView.snp.makeConstraints { make in
            make.centerX.equalTo(itemImageView.snp.trailing)
            make.centerY.equalTo(itemImageView.snp.top).offset(Constants.badgeVOffset)
        }
    }

    // MARK: - Trait changes

    private func trackTraitChanges() {
        registerForTraitChanges(
            [UITraitUserInterfaceStyle.self]
        ) { [weak self] (_: Self, _: UITraitCollection) in
            self?.updateCGColors()
        }
    }

    private func updateCGColors() {
        badgeImageView.layer.borderColor = Constants.badgeBorderColor.cgColor
    }
}

// MARK: - ConfigurableItem

extension OutgoingRequestCollectionViewCell: ConfigurableItem {

    func configure(with viewModel: ViewModel) {
        titleLabel.text = viewModel.title
        priceLabel.text = viewModel.price
        datesLabel.text = viewModel.dates
        locationLabel.text = viewModel.location
        leaserLabel.text = viewModel.leaser
        viewModel.loadImage(viewModel.imageUrl, itemImageView)
        switch viewModel.status {
        case .accepted:
            badgeImageView.image = .Status.checkmarkPrimaryFilled
        case .pending:
            badgeImageView.image = .Status.clockYellowFilled
        case .declined:
            badgeImageView.image = .Status.xmarkRedFilled
        }
        if !viewModel.actions.isEmpty {
            rightVStackView.addArrangedSubview(actionsHStackView)
        }
        viewModel.actions.forEach { action in
            let button = createActionButton(with: action)
            actionsHStackView.addArrangedSubview(button)
        }
    }

}

// MARK: - Private methods

private extension OutgoingRequestCollectionViewCell {

    func createActionButton(with action: ViewModel.Action) -> DButton {
        let button = DButton(type: action.type)
        button.title = action.title
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        button.snp.makeConstraints { make in
            make.height.equalTo(Constants.buttonHeight)
        }
        button.cornerRadius = Constants.buttonCornerRadius
        button.image = action.image
        button.setAction {
            action.action?()
        }
        return button
    }

}

// MARK: - Equatable ViewModel

extension OutgoingRequestCollectionViewCell.ViewModel: Equatable {
    static func == (
        lhs: OutgoingRequestCollectionViewCell.ViewModel,
        rhs: OutgoingRequestCollectionViewCell.ViewModel
    ) -> Bool {
        return lhs.id == rhs.id &&
            lhs.imageUrl == rhs.imageUrl &&
            lhs.title == rhs.title &&
            lhs.price == rhs.price &&
            lhs.leaser == rhs.leaser &&
            lhs.status == rhs.status &&
            lhs.actions == rhs.actions
    }
}

extension OutgoingRequestCollectionViewCell.ViewModel.Action: Equatable {
    static func == (
        lhs: OutgoingRequestCollectionViewCell.ViewModel.Action,
        rhs: OutgoingRequestCollectionViewCell.ViewModel.Action
    ) -> Bool {
        return lhs.type == rhs.type &&
        lhs.title == rhs.title &&
        lhs.image == rhs.image
    }

}
