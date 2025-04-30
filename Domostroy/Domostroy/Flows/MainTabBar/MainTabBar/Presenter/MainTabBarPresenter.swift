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
    var onTapCenterControl: EmptyClosure?

    // MARK: - Properties

    weak var view: MainTabBarViewInput?

    private var isCenterControlEnabled: Bool = false
}

// MARK: - MainTabBarModuleInput

extension MainTabBarPresenter: MainTabBarModuleInput {

    func setCenterControl(enabled: Bool) {
        self.isCenterControlEnabled = enabled
    }

    func selectTab(_ tab: MainTab) {
        view?.selectTab(tab: tab)
    }

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
        view?.setCenterControl(enabled: tab == .myOffers && isCenterControlEnabled)
    }

    func didTapCenter() {
        onTapCenterControl?()
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
