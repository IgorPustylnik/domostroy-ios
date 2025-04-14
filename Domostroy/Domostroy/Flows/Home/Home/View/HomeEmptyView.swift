//
//  HomeEmptyView.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 14.04.2025.
//

import UIKit
import SnapKit

final class HomeEmptyView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let mainVStackSpacing: CGFloat = 30
        static let insets: UIEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)
    }

    // MARK: - UI Elements

    private lazy var mainVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.mainVStackSpacing
        $0.addArrangedSubview(imageView)
        $0.addArrangedSubview(messageLabel)
        return $0
    }(UIStackView())

    private lazy var imageView = {
        $0.image = .EmptyStates.emptyBox
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())

    private lazy var messageLabel = {
        // TODO: - Localize
        $0.text = "Nothing found"
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - UI Setup

    private func setupUI() {
        addSubview(mainVStackView)

        mainVStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.insets)
        }
    }

}
