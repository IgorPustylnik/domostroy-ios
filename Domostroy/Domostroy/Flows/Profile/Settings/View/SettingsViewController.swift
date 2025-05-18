//
//  SettingsViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 18/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveDataDisplayManager

final class SettingsViewController: BaseViewController {

    // MARK: - Constants

    private enum Constants {
        static let verticalPadding: CGFloat = 16
    }

    // MARK: - Properties

    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    var adapter: ManualTableManager?

    private lazy var spinner = DLoadingIndicator()

    typealias SwitchTableCellGenerator = BaseCellGenerator<SwitchTableViewCell>
    private var firstSectionHeaderGenerator: TableHeaderGenerator?
    private var firstSectionGenerators: [TableCellGenerator] = []

    var output: SettingsViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        setupUI()
        super.viewDidLoad()
        output?.viewLoaded()
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        observeScrollOffset(tableView)
        tableView.sectionHeaderTopPadding = Constants.verticalPadding
        view.addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

}

// MARK: - SettingsViewInput

extension SettingsViewController: SettingsViewInput {

    func setupInitialState() {
        navigationBar.title = L10n.Localizable.Settings.title
    }

    func configure(with model: SettingsViewModel) {
        firstSectionHeaderGenerator = EmptyTableHeaderGenerator()
        firstSectionGenerators = [SwitchTableCellGenerator(with: model.notifications, registerType: .class)]
        refillAdapter()
    }

    func setLoading(_ isLoading: Bool) {
        spinner.isHidden = !isLoading
    }

}

// MARK: - Adapter

private extension SettingsViewController {
    func refillAdapter() {
        adapter?.clearHeaderGenerators()
        adapter?.clearCellGenerators()
        adapter?.clearFooterGenerators()

        if let firstSectionHeaderGenerator, !firstSectionGenerators.isEmpty {
            adapter?.addSection(TableHeaderGenerator: firstSectionHeaderGenerator, cells: firstSectionGenerators)
        }

        adapter?.forceRefill()
    }
}
