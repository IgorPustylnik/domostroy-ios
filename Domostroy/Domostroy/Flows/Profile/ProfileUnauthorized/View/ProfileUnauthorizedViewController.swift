//
//  ProfileUnauthorizedViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 21/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit

final class ProfileUnauthorizedViewController: ScrollViewController {

    // MARK: - Constants

    private enum Constants {
        static let mainVStackSpacing: CGFloat = 20
        static let insets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
    }

    // MARK: - UI Elements

    private lazy var mainVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.mainVStackSpacing
        $0.addArrangedSubview(authLabel)
        $0.addArrangedSubview(authButton)
        return $0
    }(UIStackView())

    private lazy var authLabel = {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        // TODO: Localize
        $0.text = "Авторизуйтесь, чтобы пользоваться всеми функциями"
        return $0
    }(UILabel())

    private lazy var authButton = {
        // TODO: Localize
        $0.setAction { [weak self] in
            self?.output?.authorize()
        }
        $0.title = "Authorize"
        return $0
    }(DButton())

    // MARK: - Properties

    var output: ProfileUnauthorizedViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
    }
}

// MARK: - ProfileUnauthorizedViewInput

extension ProfileUnauthorizedViewController: ProfileUnauthorizedViewInput {

    func setupInitialState() {
        scrollView.alwaysBounceVertical = true
        contentView.addSubview(mainVStackView)
        contentView.snp.makeConstraints { make in
            make.height.equalTo(view.safeAreaLayoutGuide)
        }
        mainVStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(Constants.insets)
        }
    }

}
