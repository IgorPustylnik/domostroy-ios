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

    // MARK: - Constants

    private enum Constants {
        static let tabBarHeight: CGFloat = 80
        static let animationDuration: Double = 0.3
    }

    // MARK: - UI Elements

    private lazy var tabBarView = MainTabBarView()

    // MARK: - Properties

    var output: MainTabBarViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.isHidden = true
        additionalSafeAreaInsets.bottom = Constants.tabBarHeight
        setupUI()
        output?.viewLoaded()
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.addSubview(tabBarView)
        tabBarView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(Constants.tabBarHeight)
        }
        tabBarView.didSelect = { [weak self] tag in
            self?.didSelect(tag)
        }
        tabBarView.didTapCenter = { [weak self] in
            self?.output?.didTapCenter()
        }
    }
}

// MARK: - MainTabBarViewInput

extension MainTabBarViewController: MainTabBarViewInput {

    func configure(controllers: [UIViewController]) {
        tabBarView.configure(with: controllers.map { $0.tabBarItem })
        viewControllers = controllers
    }

    func setCenterControl(enabled: Bool) {
        tabBarView.isCenterControlEnabled = enabled
    }

    func selectTab(tab: MainTab) {
        didSelect(tab.rawValue)
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

    func didSelect(_ tag: Int) {
        tabBarView.setSelectedIndex(tag)
        selectedViewController = viewControllers?[tag]
        if let selectedViewController {
            delegate?.tabBarController?(self, didSelect: selectedViewController)
        }
    }

}

extension MainTabBarViewController {
    func setTabBarHidden(_ hidden: Bool, animated: Bool) {
        let height = tabBarView.frame.height
        let offsetY = hidden ? height : 0

        if animated {
            tabBarView.isUserInteractionEnabled = false

            UIView.animate(
                withDuration: Constants.animationDuration,
                delay: 0,
                usingSpringWithDamping: 0.85,
                initialSpringVelocity: 0.6,
                options: [.curveEaseInOut, .beginFromCurrentState],
                animations: {
                    self.additionalSafeAreaInsets.bottom = hidden ? 0 : height
                    self.tabBarView.transform = CGAffineTransform(translationX: 0, y: offsetY)
                    self.tabBarView.alpha = hidden ? 0 : 1
                },
                completion: { _ in
                    self.tabBarView.isUserInteractionEnabled = !hidden
                }
            )
        } else {
            additionalSafeAreaInsets.bottom = hidden ? 0 : height
            tabBarView.transform = CGAffineTransform(translationX: 0, y: offsetY)
            tabBarView.alpha = hidden ? 0 : 1
            tabBarView.isUserInteractionEnabled = !hidden
        }
    }
}
