//
//  MainTabBarPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class MainTabBarPresenter: MainTabBarModuleOutput {

    // MARK: - MainTabBarModuleOutput

    var onHomeFlowSelect: TabSelectClosure?
    var onFavoritesFlowSelect: TabSelectClosure?
    var onMyOffersFlowSelect: TabSelectClosure?
    var onRequestsFlowSelect: TabSelectClosure?
    var onProfileFlowSelect: TabSelectClosure?
    var onAdd: EmptyClosure?

    // MARK: - Properties

    weak var view: MainTabBarViewInput?
}

// MARK: - MainTabBarModuleInput

extension MainTabBarPresenter: MainTabBarModuleInput {

}

// MARK: - MainTabBarViewOutput

extension MainTabBarPresenter: MainTabBarViewOutput {

    func selectTab(with tab: MainTab, isInitial: Bool) {
        switch tab {
        case .home:
            onHomeFlowSelect?(isInitial)
        case .favorites:
            onFavoritesFlowSelect?(isInitial)
        case .myOffers:
            onMyOffersFlowSelect?(isInitial)
        case .requests:
            onRequestsFlowSelect?(isInitial)
        case .profile:
            onProfileFlowSelect?(isInitial)
        }
        // TODO: Implement decision whether to show center button
        view?.setAdd(enabled: tab.rawValue == 2)
    }

    func add() {
        onAdd?()
    }
}

// MARK: ModuleConfigurator

extension MainTabBarPresenter {

    func configureTabs() {
        var controllers: [UIViewController] = []
        for tab in MainTab.allCases {
            let tabBarItem = UITabBarItem(title: nil, image: tab.image, selectedImage: tab.selectedImage)
            tabBarItem.tag = tab.rawValue

            let navigationController = UINavigationController()
            navigationController.tabBarItem = tabBarItem
            controllers.append(navigationController)
        }
        view?.configure(controllers: controllers)
    }
}
