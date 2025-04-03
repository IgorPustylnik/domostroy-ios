//
//  MainTabBarItemView.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 03.04.2025.
//

import UIKit
import SnapKit

final class MainTabBarItemView: UIView {

    // MARK: - UI Elements

    private lazy var imageView = UIImageView(image: tab.image, highlightedImage: tab.selectedImage)

    private lazy var contentView: UIView = {
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        $0.addSubview(imageView)
        return $0
    } (UIView())

    // MARK: - Init

    init(tabBarItem: UITabBarItem) {
        self.tab = tabBarItem
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Properties

    private var tab: UITabBarItem

    var didSelect: (() -> Void)?

    var isEnabled: Bool = true {
        didSet {
            alpha = isEnabled ? 1 : 0
            contentView.isUserInteractionEnabled = isEnabled
        }
    }

    var isSelected: Bool = false {
        didSet {
            imageView.isHighlighted = isSelected
        }
    }

    // MARK: - UI Setup

    private func setupUI() {
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }

}

// MARK: - Selectors

private extension MainTabBarItemView {

    @objc
    func tap() {
        didSelect?()
    }

}
