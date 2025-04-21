//
//  FavoritesSettingsView.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 21.04.2025.
//

import UIKit
import SnapKit

final class FavoritesSettingsView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let mainHStackSpacing: CGFloat = 10
        static let imageSize: CGSize = .init(width: 18, height: 18)
    }

    // MARK: - UI Elements

    private lazy var mainHStackView = {
        $0.axis = .horizontal
        $0.addArrangedSubview(sortButton)
        $0.addArrangedSubview(spacerView)
        return $0
    }(UIStackView())

    private lazy var sortButton = {
        $0.image = .Search.sort.withTintColor(.label, renderingMode: .alwaysOriginal)
        $0.imageSize = Constants.imageSize
        $0.setAction { [weak self] in
            self?.onOpenSort?()
        }
        return $0
    }(DButton(type: .navbar))

    private lazy var spacerView = UIView()

    // MARK: - Properties

    var onOpenSort: EmptyClosure?

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

}

// MARK: - Configuration

extension FavoritesSettingsView {
    func set(sort: String) {
        sortButton.title = sort
    }
}
