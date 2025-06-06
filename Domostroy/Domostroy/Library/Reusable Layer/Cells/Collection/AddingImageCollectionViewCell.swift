//
//  AddingImageCollectionViewCell.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 16.04.2025.
//

import UIKit
import SnapKit
import ReactiveDataDisplayManager

final class AddingImageCollectionViewCell: UICollectionViewCell, HighlightableScaleView {

    var highlightScaleFactor: CGFloat = 0.97

    // MARK: - ViewModel

    struct ViewModel {
        let onDelete: EmptyClosure?
        let url: URL?
        let loadImage: LoadImageClosure
    }

    // MARK: - Constants

    private enum Constants {
        static let buttonPadding: UIEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        static let buttonSize: CGSize = .init(width: 24, height: 24)
        static let cornerRadius: CGFloat = 22
        static let borderWidth: CGFloat = 1
        static let borderColor: UIColor = .separator
        static let xmarkSize: CGSize = .init(width: 10, height: 10)
    }

    // MARK: - UI Elements

    private lazy var imageView = {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        return $0
    }(UIImageView())

    private lazy var spinner = DLoadingIndicator()

    private lazy var deleteButton = {
        $0.cornerRadius = 6
        $0.image = .TextField.xmark.withTintColor(.black, renderingMode: .alwaysOriginal)
        $0.imageSize = Constants.xmarkSize
        return $0
    }(DButton(type: .filledWhite))

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
        imageView.image = nil
        deleteButton.removeTarget(nil, action: nil, for: .allEvents)
    }

    // MARK: - UI Setup

    private func setupUI() {
        backgroundColor = .systemBackground
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true
        layer.borderColor = Constants.borderColor.cgColor
        layer.borderWidth = Constants.borderWidth

        addSubview(imageView)
        addSubview(deleteButton)
        addSubview(spinner)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        deleteButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(Constants.buttonPadding)
            make.size.equalTo(Constants.buttonSize)
        }
        spinner.snp.makeConstraints { make in
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

extension AddingImageCollectionViewCell: ConfigurableItem {

    func configure(with model: ViewModel) {
        spinner.isHidden = false
        model.loadImage(imageView) { [weak self] in
            self?.spinner.isHidden = true
        }
        deleteButton.setAction {
            model.onDelete?()
        }
    }

}
