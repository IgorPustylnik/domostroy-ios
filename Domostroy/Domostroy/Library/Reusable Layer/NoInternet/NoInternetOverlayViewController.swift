//
//  NoInternetOverlayViewController.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 01.06.2025.
//

import Foundation

import UIKit
import SnapKit

final class NoInternetOverlayViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let insets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let mainVStackSpacing: CGFloat = 30
    }

    // MARK: - UI Elements

    private lazy var blurView = {
        return $0
    }(UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial)))

    private lazy var mainVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.mainVStackSpacing
        return $0
    }(UIStackView(
        arrangedSubviews: [imageView, titleLabel, retryButton])
    )

    private lazy var imageView = {
        $0.contentMode = .scaleAspectFit
        $0.image = .NoInternet.noInternet
        return $0
    }(UIImageView())

    private lazy var titleLabel = {
        $0.text = L10n.Localizable.NoInternet.title
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textAlignment = .center
        return $0
    }(UILabel())

    private(set) lazy var retryButton = {
        $0.title = L10n.Localizable.NoInternet.Button.retry
        return $0
    }(DButton())

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.addSubview(blurView)
        view.addSubview(mainVStackView)

        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mainVStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(Constants.insets)
            make.center.equalToSuperview()
        }
    }
}
