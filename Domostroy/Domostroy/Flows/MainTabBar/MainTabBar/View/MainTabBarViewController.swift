//
//  MainTabBarViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit

final class MainTabBarViewController: UITabBarController {

    // MARK: - UI Elements

    private lazy var tabBarView = MainTabBarView()

    // MARK: - Properties

    var output: MainTabBarViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.isHidden = true
        setupUI()
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.addSubview(tabBarView)
        tabBarView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
        tabBarView.didSelect = { [weak self] tag in
            self?.didSelect(tag)
        }
        tabBarView.didTapCenter = { [weak self] in
            self?.output?.add()
        }
    }
}

// MARK: - MainTabBarViewInput

extension MainTabBarViewController: MainTabBarViewInput {

    func configure(controllers: [UIViewController]) {
        tabBarView.configure(with: controllers.map { $0.tabBarItem })
        viewControllers = controllers
        didSelect(0)
    }

    func setAdd(enabled: Bool) {
        tabBarView.isCenterButtonEnabled = enabled
    }

}

// MARK: - UITabBarControllerDelegate

extension MainTabBarViewController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let tab = MainTab(rawValue: viewController.tabBarItem.tag) else {
            return
        }
        let navigationController = viewController as? UINavigationController
        let isInitial = navigationController?.viewControllers.isEmpty ?? true
        output?.selectTab(with: tab, isInitial: isInitial)
    }

}

// MARK: - Configuration

private extension MainTabBarViewController {

    private func didSelect(_ tag: Int) {
        tabBarView.setSelectedIndex(tag)
        selectedViewController = viewControllers?[tag]
        if let selectedViewController {
            delegate?.tabBarController?(self, didSelect: selectedViewController)
        }
    }

}
