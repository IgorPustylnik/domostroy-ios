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
        static let horizontalInsets: CGFloat = 16
        static let imageSize: CGSize = .init(width: 219, height: 194)
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
        $0.image = .EmptyStates.toolbox
        $0.contentMode = .scaleAspectFit
        $0.snp.makeConstraints { make in
            make.size.equalTo(Constants.imageSize)
        }
        return $0
    }(UIImageView())

    private lazy var messageLabel = {
        // TODO: - Localize
        $0.text = "You have not posted any offers yet"
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
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalInsets)
        }
    }

}
