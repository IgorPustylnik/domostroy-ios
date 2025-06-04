//
//  OnboardingPageCollectionViewCell.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 31.05.2025.
//

import UIKit
import ReactiveDataDisplayManager

final class OnboardingPageCollectionViewCell: UICollectionViewCell {

    // MARK: - ViewModel

    typealias Model = OnboardingPageModel

    // MARK: - Constants

    private enum Constants {
        static let insets: UIEdgeInsets = .init(top: 16, left: 32, bottom: 16, right: 32)
        static let mainVStackSpacing: CGFloat = 30
    }

    // MARK: - UI Elements

    private lazy var mainVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.mainVStackSpacing
        $0.alignment = .center
        return $0
    }(UIStackView(
        arrangedSubviews: [UIView(), imageView, titleLabel, descriptionLabel, UIView()])
    )

    private lazy var imageView = {
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())

    private lazy var titleLabel = {
        $0.font = .systemFont(ofSize: 24, weight: .semibold)
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.textColor = .white
        return $0
    }(UILabel())

    private lazy var descriptionLabel = {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = .white
        return $0
    }(UILabel())

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    private func setupUI() {
        addSubview(mainVStackView)
        mainVStackView.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualToSuperview().inset(Constants.insets)
            make.trailing.lessThanOrEqualToSuperview().inset(Constants.insets)
            make.center.equalToSuperview()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
    }

}

// MARK: - ConfigurableItem

extension OnboardingPageCollectionViewCell: ConfigurableItem {
    func configure(with model: Model) {
        imageView.image = model.image
        titleLabel.text = model.title
        descriptionLabel.text = model.description
    }
}
