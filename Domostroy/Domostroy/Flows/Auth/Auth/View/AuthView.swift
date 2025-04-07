//
//  AuthView.swift
//  Domostroy
//
//  Created by igorpustylnik on 04/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit

final class AuthView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let vSpacing: CGFloat = 20
        static let insets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
    }

    // MARK: - UI Elements

    private lazy var vStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.vSpacing
        $0.addArrangedSubview(messageLabel)
        $0.addArrangedSubview(loginButton)
        $0.addArrangedSubview(registerButton)
        return $0
    }(UIStackView())

    private lazy var messageLabel: UILabel = {
        // TODO: Localize
        $0.text = "Login or register to be able to use all functions."
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        return $0
    }(UILabel())

    private lazy var loginButton: DButton = {
        // TODO: Localize
        $0.title = "Login"
        $0.setAction { [weak self] in
            self?.login?()
        }
        return $0
    }(DButton(type: .filledPrimary))

    private lazy var registerButton: DButton = {
        // TODO: Localize
        $0.title = "Register"
        $0.setAction { [weak self] in
            self?.register?()
        }
        return $0
    }(DButton(type: .plainPrimary))

    // MARK: - Properties

    var login: EmptyClosure?
    var register: EmptyClosure?

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
        backgroundColor = .systemBackground
        addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(Constants.insets)
        }
    }

}
