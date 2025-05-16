//
//  SelectCityViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 01/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveDataDisplayManager

final class SelectCityViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let insets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
    }

    // MARK: - UI Elements

    private lazy var searchTextField = {
        $0.containerColor = .systemBackground
        $0.onTextChange = { [weak self] textField in
            self?.output?.search(query: textField.text)
        }
        $0.onCancel = { textField in
            textField.text = ""
            textField.sendActions(for: .editingChanged)
        }
        return $0
    }(DSearchTextField())

    var adapter: ManualTableManager?

    typealias CityCellGenerator = BaseCellGenerator<CityTableViewCell>

    private var listGenerators: [CityCellGenerator] = []

    private(set) var tableView = UITableView(frame: .zero, style: .insetGrouped)

    private lazy var activityIndicator = DLoadingIndicator()

    private lazy var applyButton = {
        $0.title = L10n.Localizable.SelectCity.Button.apply
        $0.setAction { [weak self] in
            self?.output?.apply()
        }
        return $0
    }(DButton())

    // MARK: - Properties

    var output: SelectCityViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupUI()
        output?.viewLoaded()
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        view.addSubview(searchTextField)
        view.addSubview(tableView)
        view.addSubview(applyButton)

        searchTextField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(Constants.insets)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(Constants.insets.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.greaterThanOrEqualTo(applyButton.snp.top).offset(-Constants.insets.bottom)
        }
        applyButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(Constants.insets)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
                .inset(Constants.insets.bottom)
                .priority(.high)
            make.bottom.lessThanOrEqualTo(view.keyboardLayoutGuide.snp.top)
                .offset(-Constants.insets.bottom)
                .priority(.required)
        }
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { $0.center.equalToSuperview() }
    }

    private func setupNavigationController() {
        title = L10n.Localizable.SelectCity.title
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .close, target: self, action: #selector(close))
    }
}

// MARK: - SelectCityViewInput

extension SelectCityViewController: SelectCityViewInput {

    func setupInitialState() {

    }

    func setLoading(_ isLoading: Bool) {
        activityIndicator.isHidden = !isLoading
    }

    func setItems(with viewModels: [CityTableViewCell.ViewModel]) {
        listGenerators = viewModels.map {
            let generator = CityCellGenerator(with: $0, registerType: .class)
            generator.didSelectEvent += { [viewModel = $0] in
                viewModel.selectionHandler()
            }
            return generator
        }
        refillAdapter()
    }

}

// MARK: - Private methods

private extension SelectCityViewController {
    func refillAdapter() {
        adapter?.clearCellGenerators()
        adapter?.addCellGenerators(listGenerators)
        adapter?.forceRefill()
    }
}

// MARK: - Selectors

@objc
private extension SelectCityViewController {
    func close() {
        output?.dismiss()
    }
}
