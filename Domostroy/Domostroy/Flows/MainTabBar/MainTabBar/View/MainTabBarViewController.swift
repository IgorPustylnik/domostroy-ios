//
//  MainTabBarViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class MainTabBarViewController: UITabBarController {

    // MARK: - Properties

    var output: MainTabBarViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        configureAppearance()
        configureControllers()
    }
}

// MARK: - MainTabBarViewInput

extension MainTabBarViewController: MainTabBarViewInput {

    func setupInitialState() {

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

    func configureAppearance() {
        tabBar.barTintColor = UIColor.clear
        tabBar.tintColor = .Domostroy.primary
        tabBar.unselectedItemTintColor = .Domostroy.primary
    }

    func configureControllers() {
        var controllers: [UIViewController] = []
        for tab in MainTab.allCases {
            let tabBarItem = UITabBarItem(title: nil, image: tab.image, selectedImage: tab.selectedImage)
            tabBarItem.tag = tab.rawValue

            let navigationController = UINavigationController()
            navigationController.tabBarItem = tabBarItem
            controllers.append(navigationController)
        }
        viewControllers = controllers
    }

}
