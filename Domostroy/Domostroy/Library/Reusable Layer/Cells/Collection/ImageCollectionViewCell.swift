//
//  ImageCollectionViewCell.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 10.04.2025.
//

import UIKit
import SnapKit
import ReactiveDataDisplayManager

typealias LoadImageClosure = (UIImageView, @escaping () -> Void) -> Void

final class ImageCollectionViewCell: UICollectionViewCell {

    // MARK: - ViewModel

    struct ViewModel {
        let imageUrl: URL?
        let loadImage: LoadImageClosure
    }

    // MARK: - UI Elements

    private lazy var imageView = {
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())

    private lazy var spinner = DLoadingIndicator()

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
        imageView.image = nil
    }

    // MARK: - UI Setup

    private func setupUI() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

}

// MARK: - ConfigurableItem

extension ImageCollectionViewCell: ConfigurableItem {
    typealias Model = ViewModel

    func configure(with model: ViewModel) {
        spinner.isHidden = false
        model.loadImage(imageView) { [weak self] in
            self?.spinner.isHidden = true
        }
    }

}
