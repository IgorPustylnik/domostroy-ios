//
//  AdminPanelViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 21/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveDataDisplayManager

final class AdminPanelViewController: BaseViewController {

    // MARK: - UI Elements

    private lazy var segmentedControl = UISegmentedControl()

    private var currentViewController: UIViewController?
    private lazy var contentView = UIView()

    // MARK: - Properties

    var output: AdminPanelViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        setupContentView()
        super.viewDidLoad()
        setupNavbar()
        output?.viewLoaded()
    }

    private func setupContentView() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupNavbar() {
        navigationBar.title = L10n.Localizable.AdminPanel.title
        navigationBar.addArrangedSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(segmentedControlChangedIndex(_:)), for: .valueChanged)
    }

}

// MARK: - AdminPanelViewInput

extension AdminPanelViewController: AdminPanelViewInput {
    func setupSegments(_ values: [String], selectedIndex: Int) {
        segmentedControl.removeAllSegments()
        for (index, value) in values.enumerated() {
            segmentedControl.insertSegment(withTitle: value, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = selectedIndex
    }

    func setRoot(_ presentable: Presentable, scrollView: UIScrollView?) {
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()

        guard let vc = presentable.toPresent() else {
            return
        }
        addChild(vc)
        vc.didMove(toParent: self)

        observeScrollOffset(scrollView)

        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        currentViewController = vc
    }
}

@objc
private extension AdminPanelViewController {
    func segmentedControlChangedIndex(_ sender: UISegmentedControl) {
        output?.selectSegment(sender.selectedSegmentIndex)
    }
}
