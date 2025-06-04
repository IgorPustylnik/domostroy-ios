//
//  ConciseOfferView.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 12.05.2025.
//

import UIKit
import SnapKit

final class ConciseOfferView: UIView {

    // MARK: - ViewModel

    struct ViewModel {
        let imageUrl: URL?
        let loadImage: (URL?, UIImageView) -> Void
        let title: String
        let price: String
    }

    // MARK: - Constants

    private enum Constants {
        static let itemImageSize: CGSize = .init(width: 40, height: 40)
        static let mainHStackSpacing: CGFloat = 16
    }

    // MARK: - UI Elements

    private lazy var mainHStackView = {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = Constants.mainHStackSpacing
        $0.addArrangedSubview(itemImageView)
        $0.addArrangedSubview(titleLabel)
        $0.addArrangedSubview(UIView())
        $0.addArrangedSubview(priceLabel)
        return $0
    }(UIStackView())

    private lazy var itemImageView = {
        $0.layer.cornerRadius = Constants.itemImageSize.width / 5
        $0.layer.masksToBounds = true
        $0.backgroundColor = .secondarySystemBackground
        $0.contentMode = .scaleAspectFill
        $0.snp.makeConstraints { make in
            make.size.equalTo(Constants.itemImageSize)
        }
        return $0
    }(UIImageView())

    private lazy var titleLabel = {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private lazy var priceLabel = {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .secondaryLabel
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
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
        addSubview(mainHStackView)
        mainHStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Configuration

    func configure(with viewModel: ViewModel) {
        viewModel.loadImage(viewModel.imageUrl, itemImageView)
        titleLabel.text = viewModel.title
        priceLabel.text = viewModel.price
    }
}
