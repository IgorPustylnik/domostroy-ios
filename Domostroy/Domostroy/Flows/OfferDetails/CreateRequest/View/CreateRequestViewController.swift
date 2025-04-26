//
//  CreateRequestViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 17/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit

final class CreateRequestViewController: ScrollViewController {

    // MARK: - Constants

    private enum Constants {
        static let insets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let buttonInsets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
    }

    // MARK: - UI Elements

    private var createRequestView = CreateRequestView()

    private lazy var submitButton = {
        $0.title = L10n.Localizable.CreateRequest.Button.submit
        $0.setAction { [weak self] in
            self?.output?.submit()
        }
        return $0
    }(DButton())

    // MARK: - Properties

    var output: CreateRequestViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        setupUI()
        super.viewDidLoad()
        addSubmitButton()
        navigationBar.title = L10n.Localizable.CreateRequest.title
        hidesTabBar = true
        scrollView.alwaysBounceVertical = true
        output?.viewLoaded()
    }

    // MARK: - UI Setup

    private func setupUI() {
        contentView.addSubview(createRequestView)
        createRequestView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.insets)
        }

    }

    private func addSubmitButton() {
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Constants.buttonInsets)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-Constants.buttonInsets.bottom)
        }
    }

}

// MARK: - CreateRequestViewInput

extension CreateRequestViewController: CreateRequestViewInput {

    func setupInitialState() {

    }

    func configure(with viewModel: CreateRequestView.ViewModel) {
        createRequestView.configure(with: viewModel)
    }

    func configureCalendar(with description: String) {
        createRequestView.configureCalendar(with: description)
    }

    func configureTotalCost(with totalCost: String?) {
        createRequestView.configureTotalCost(with: totalCost)
    }

}
