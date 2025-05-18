//
//  CategoryCollectionViewCell.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 18.05.2025.
//

import Foundation
import UIKit
import SnapKit
import ReactiveDataDisplayManager

final class CategoryCollectionViewCell: UICollectionViewCell, HighlightableScaleView {

    var highlightScaleFactor: CGFloat = 0.97

    typealias Model = ViewModel

    // MARK: - ViewModel

    struct ViewModel: Equatable {
        let id: Int
        let title: String
    }

    // MARK: - Constants

    private enum Constants {
        static let insets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let borderWidth: CGFloat = 1
        static let borderColor: UIColor = .separator
        static let cornerRadius: CGFloat = 12
    }

    // MARK: - UI Elements

    private lazy var titleLabel: UILabel = {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        return $0
    }(UILabel())

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
    }

    // MARK: - Setup UI

    private func setupUI() {
        backgroundColor = .systemBackground
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.insets).priority(.high)
        }
        layer.borderWidth = Constants.borderWidth
        layer.borderColor = Constants.borderColor.cgColor
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true
    }

    private func trackTraitChanges() {
        registerForTraitChanges(
            [UITraitUserInterfaceStyle.self]
        ) { [weak self] (_: Self, _: UITraitCollection) in
            self?.updateCGColors()
        }
    }

    private func updateCGColors() {
        layer.borderColor = Constants.borderColor.cgColor
    }
}

// MARK: - ConfigurableItem

extension CategoryCollectionViewCell: ConfigurableItem {

    func configure(with viewModel: ViewModel) {
        titleLabel.text = viewModel.title
    }

}
