//
//  AuthViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 04/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit

final class AuthViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let vSpacing: CGFloat = 20
        static let insets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let totalHeight: CGFloat = 180
    }

    // MARK: - UI Elements

    private lazy var vStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.vSpacing
        $0.addArrangedSubview(loginButton)
        $0.addArrangedSubview(registerButton)
        return $0
    }(UIStackView())

    private lazy var loginButton: DButton = {
        $0.title = L10n.Localizable.Auth.Button.login
        $0.setAction { [weak self] in
            self?.output?.login()
        }
        return $0
    }(DButton(type: .filledPrimary))

    private lazy var registerButton: DButton = {
        $0.title = L10n.Localizable.Auth.Button.register
        $0.setAction { [weak self] in
            self?.output?.register()
        }
        return $0
    }(DButton(type: .plainPrimary))

    // MARK: - Properties

    var output: AuthViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
    }
}

// MARK: - AuthViewInput

extension AuthViewController: AuthViewInput {

    func setupInitialState() {
        view.backgroundColor = .systemBackground
        view.addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Constants.insets)
        }

        if let sheet = sheetPresentationController {
            sheet.detents = [
                .custom(resolver: { _ in
                    Constants.totalHeight
                })
            ]
            sheet.prefersGrabberVisible = true
        }
    }

}
