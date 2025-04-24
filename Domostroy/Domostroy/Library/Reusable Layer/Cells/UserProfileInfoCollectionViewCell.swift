//
//  UserProfileInfoCollectionViewCell.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 24.04.2025.
//

import UIKit
import SnapKit
import ReactiveDataDisplayManager

final class UserProfileInfoCollectionViewCell: UICollectionViewCell {

    typealias Model = ViewModel

    // MARK: - ViewModel

    struct ViewModel {
        let imageUrl: URL?
        let loadImage: ((URL?, UIImageView) -> Void)?
        let username: String?
        let info1: String?
        let info2: String?

        func height(forWidth width: CGFloat) -> CGFloat {
            let horizontalInsets: CGFloat = Constants.insets.top + Constants.insets.bottom
            let availableTextWidth = width - horizontalInsets - Constants.avatarSize.width - Constants.mainHStackSpacing

            let usernameHeight = (username ?? "").heightForWidth(availableTextWidth, font: Constants.usernameFont)
            let info1Height = (info1 ?? "").heightForWidth(availableTextWidth, font: Constants.info1Font)
            let info2Height = (info2 ?? "").heightForWidth(availableTextWidth, font: Constants.info2Font)

            let textHeight = usernameHeight + info1Height + info2Height + 2 * Constants.infoVStackSpacing

            let contentHeight = max(textHeight, Constants.avatarSize.height)
            return contentHeight + Constants.insets.bottom
        }
    }

    // MARK: - Constants

    private enum Constants {
        static let mainHStackSpacing: CGFloat = 10
        static let infoVStackSpacing: CGFloat = 5
        static let avatarSize: CGSize = .init(width: 80, height: 80)
        static let insets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 16, right: 0)
        static let usernameFont: UIFont = .systemFont(ofSize: 20, weight: .regular)
        static let info1Font: UIFont = .systemFont(ofSize: 14, weight: .regular)
        static let info2Font: UIFont = .systemFont(ofSize: 14, weight: .regular)
    }

    // MARK: - UI Elements

    private lazy var mainHStackView = {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.spacing = Constants.mainHStackSpacing
        $0.addArrangedSubview(infoVStackView)
        $0.addArrangedSubview(avatarImageView)
        return $0
    }(UIStackView())

    private lazy var infoVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.infoVStackSpacing
        $0.addArrangedSubview(usernameLabel)
        $0.addArrangedSubview(info1Label)
        $0.addArrangedSubview(info2Label)
        return $0
    }(UIStackView())

    private lazy var usernameLabel = {
        $0.font = Constants.usernameFont
        return $0
    }(UILabel())

    private lazy var info1Label = {
        $0.font = Constants.info1Font
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private lazy var info2Label = {
        $0.font = Constants.info2Font
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private lazy var avatarImageView = {
        $0.backgroundColor = .secondarySystemBackground
        $0.layer.cornerRadius = Constants.avatarSize.width / 2
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.snp.makeConstraints { make in
            make.size.equalTo(Constants.avatarSize)
        }
        return $0
    }(UIImageView())

    private lazy var bottomLineView = {
        $0.backgroundColor = .separator
        return $0
    }(UIView())

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        usernameLabel.text = nil
        info1Label.text = nil
        info2Label.text = nil
        avatarImageView.image = nil
        super.prepareForReuse()
    }

    // MARK: - Setup UI

    private func setupUI() {
        backgroundColor = .systemBackground
        addSubview(mainHStackView)
        addSubview(bottomLineView)

        mainHStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.insets)
        }
        bottomLineView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.height.equalTo(1 / (window?.screen.scale ?? 2))
        }
    }
}

// MARK: - ConfigurableItem

extension UserProfileInfoCollectionViewCell: ConfigurableItem {

    func configure(with viewModel: ViewModel) {
        usernameLabel.text = viewModel.username
        info1Label.text = viewModel.info1
        info2Label.text = viewModel.info2
        viewModel.loadImage?(viewModel.imageUrl, avatarImageView)
    }

}

// MARK: - CalculatableHeightItem

extension UserProfileInfoCollectionViewCell: CalculatableHeightItem {

    static func getHeight(forWidth width: CGFloat, with model: ViewModel) -> CGFloat {
        return model.height(forWidth: width)
    }

}

// MARK: - Equatable ViewModel

extension UserProfileInfoCollectionViewCell.ViewModel: Equatable {
    static func ==(
        lhs: UserProfileInfoCollectionViewCell.ViewModel,
        rhs: UserProfileInfoCollectionViewCell.ViewModel
    ) -> Bool {
        return lhs.imageUrl == rhs.imageUrl &&
        lhs.username == rhs.username &&
        lhs.info1 == rhs.info1 &&
        lhs.info2 == rhs.info2
    }
}
