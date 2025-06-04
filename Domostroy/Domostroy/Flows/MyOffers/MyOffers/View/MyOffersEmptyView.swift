//
//  MyOffersEmptyView.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit

final class MyOffersEmptyView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let mainVStackSpacing: CGFloat = 30
        static let insets: UIEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)
    }

    // MARK: - UI Elements

    private lazy var mainVStackView = {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = Constants.mainVStackSpacing
        $0.addArrangedSubview(imageView)
        $0.addArrangedSubview(messageLabel)
        return $0
    }(UIStackView())

    private lazy var imageView = {
        $0.image = .EmptyStates.toolbox
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())

    private lazy var messageLabel = {
        $0.text = L10n.Localizable.Offers.MyOffers.Empty.message
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
