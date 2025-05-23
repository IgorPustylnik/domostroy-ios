//
//  OfferAdminCollectionViewCell.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 23.05.2025.
//

import UIKit
import SnapKit
import ReactiveDataDisplayManager

final class OfferAdminCollectionViewCell: UICollectionViewCell, HighlightableScaleView {

    var highlightScaleFactor: CGFloat = 0.97

    // MARK: - ViewModel

    struct ViewModel {
        let id: Int
        let loadImage: (UIImageView) -> Void
        let title: String
        let description: String
        let price: String
        let location: String
        let isBanned: Bool
        let banReason: String
        let banAction: ToggleAction?
        let deleteAction: (_ handler: ((_ success: Bool) -> Void)?) -> Void?
    }

    // MARK: - Constants

    private enum Constants {
        static let mainHStackSpacing: CGFloat = 16
        static let imageViewSize: CGSize = .init(width: 100, height: 84)
        static let imageViewCornerRadius: CGFloat = 8
        static let rightVStackSpacing: CGFloat = 10
        static let infoVStackSpacing: CGFloat = 5
        static let buttonsHStackViewSpacing: CGFloat = 8
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

    private lazy var rightVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.rightVStackSpacing
        $0.addArrangedSubview(infoVStackView)
        $0.addArrangedSubview(buttonsHStackView)
        return $0
    }(UIStackView())

    private lazy var infoVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.infoVStackSpacing
        $0.addArrangedSubview(titleLabel)
        $0.addArrangedSubview(priceLabel)
        $0.addArrangedSubview(descriptionLabel)
        $0.addArrangedSubview(cityLabel)
        $0.addArrangedSubview(banReasonLabel)
        return $0
    }(UIStackView())

    private lazy var titleLabel = {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.numberOfLines = 2
        return $0
    }(UILabel())

    private lazy var descriptionLabel = {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 2
        return $0
    }(UILabel())

    private lazy var priceLabel = {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.numberOfLines = 1
        return $0
    }(UILabel())

    private lazy var cityLabel = {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        return $0
    }(UILabel())

    private lazy var banReasonLabel = {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private lazy var buttonsHStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = Constants.buttonsHStackViewSpacing
        $0.addArrangedSubview(banButton)
        $0.addArrangedSubview(deleteButton)
        return $0
    }(UIStackView())

    private lazy var banButton = {
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        $0.cornerRadius = Constants.buttonCornerRadius
        $0.onColor = UIColor { $0.userInterfaceStyle == .dark ? .secondarySystemBackground : .black }
        $0.offColor = .Domostroy.primary
        $0.onTitleColor = .white
        $0.offTitleColor = .white
        $0.onTitle = L10n.Localizable.AdminPanel.Users.Button.ban
        $0.offTitle = L10n.Localizable.AdminPanel.Users.Button.unban
        $0.snp.makeConstraints { make in
            make.height.equalTo(Constants.buttonHeight)
        }
        return $0
    }(DToggleButton())

    private lazy var deleteButton = {
        $0.backgroundColor = .systemRed
        $0.title = L10n.Localizable.AdminPanel.Users.Button.delete
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        $0.cornerRadius = Constants.buttonCornerRadius
        $0.snp.makeConstraints { make in
            make.height.equalTo(Constants.buttonHeight)
        }
        return $0
    }(DButton())

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
        cityLabel.text = nil
        banReasonLabel.text = nil
        banButton.removeTarget(nil, action: nil, for: .allEvents)
        deleteButton.removeTarget(nil, action: nil, for: .allEvents)
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

extension OfferAdminCollectionViewCell: ConfigurableItem {

    func configure(with viewModel: ViewModel) {
        viewModel.loadImage(itemImageView)
        titleLabel.text = viewModel.title
        priceLabel.text = viewModel.price
        descriptionLabel.text = viewModel.description
        cityLabel.text = viewModel.location
        banReasonLabel.text = viewModel.banReason
        banButton.setOn(!viewModel.isBanned)
        banButton.setToggleAction(viewModel.banAction)
        deleteButton.setAction { [weak self] in
            self?.deleteButton.setLoading(true)
            viewModel.deleteAction { success in
                self?.deleteButton.setLoading(false)
            }
        }
    }

}

// MARK: - Equatable ViewModel

extension OfferAdminCollectionViewCell.ViewModel: Equatable {
    static func ==(
        lhs: OfferAdminCollectionViewCell.ViewModel,
        rhs: OfferAdminCollectionViewCell.ViewModel
    ) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.description == rhs.description &&
        lhs.price == rhs.price &&
        lhs.location == rhs.location &&
        lhs.isBanned == rhs.isBanned &&
        lhs.banReason == rhs.banReason
    }
}
