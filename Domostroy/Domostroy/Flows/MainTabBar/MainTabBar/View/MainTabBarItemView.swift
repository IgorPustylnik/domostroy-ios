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

    private lazy var button = {
        $0.image = tab.image
        $0.setAction { [weak self] in
            self?.didSelect?()
        }
        return $0
    }(DButton(type: .plainPrimary))

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
            button.isUserInteractionEnabled = isEnabled
        }
    }

    var isSelected: Bool = false {
        didSet {
            button.image = isSelected ? tab.selectedImage : tab.image
        }
    }

    // MARK: - UI Setup

    private func setupUI() {
        addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
