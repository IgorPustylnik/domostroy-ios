//
//  AddImageButtonCollectionViewCell.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 17.04.2025.
//

import UIKit
import SnapKit
import ReactiveDataDisplayManager

final class AddImageButtonCollectionViewCell: UICollectionViewCell, HighlightableScaleView {

    var highlightScaleFactor: CGFloat = 0.97

    // MARK: - Constants

    private enum Constants {
        static let cornerRadius: CGFloat = 22
        static let borderWidth: CGFloat = 1
        static let borderColor: UIColor = .separator
        static let stackSpacing: CGFloat = 10
        static let xmarkSize: CGSize = .init(width: 10, height: 10)
    }

    // MARK: - UI Elements

    private lazy var addImageVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.stackSpacing
        $0.addArrangedSubview(galleryImageView)
        $0.addArrangedSubview(addPhotoLabel)
        return $0
    }(UIStackView())

    private lazy var galleryImageView = {
        $0.image = .Buttons.gallery.withTintColor(.Domostroy.primary, renderingMode: .alwaysOriginal)
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())

    private lazy var addPhotoLabel = {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .Domostroy.primary
        // TODO: Localize
        $0.text = "Add photo"
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

    // MARK: - UI Setup

    private func setupUI() {
        backgroundColor = .systemBackground
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true
        layer.borderColor = Constants.borderColor.cgColor
        layer.borderWidth = Constants.borderWidth
        addSubview(addImageVStackView)
        addImageVStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
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

extension AddImageButtonCollectionViewCell: ConfigurableItem {

    func configure(with model: Bool) {}

}
