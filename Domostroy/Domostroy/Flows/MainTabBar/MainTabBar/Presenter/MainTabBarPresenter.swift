//
//  MainTabBarPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import Combine

final class MainTabBarPresenter: MainTabBarModuleOutput {

    // MARK: - MainTabBarModuleOutput

    var onHomeFlowSelect: TabSelectClosure?
    var onFavoritesFlowSelect: TabSelectClosure?
    var onMyOffersFlowSelect: TabSelectClosure?
    var onRequestsFlowSelect: TabSelectClosure?
    var onProfileFlowSelect: TabSelectClosure?
    var onTapCenterControl: EmptyClosure?
    var onShowSelectServerHost: EmptyClosure?

    // MARK: - Properties

    weak var view: MainTabBarViewInput?

    private var userService: UserService? = ServiceLocator.shared.resolve()
    private var cancellables: Set<AnyCancellable> = .init()

    private var isCenterControlEnabled: Bool = false

    private var profileTapCount = 0
    private var lastProfileTapTime: Date?
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
            handleProfileTap(isInitial: isInitial)
        }
        view?.setCenterControl(enabled: tab == .myOffers && isCenterControlEnabled)
    }

    func didTapCenter() {
        onTapCenterControl?()
    }

    private func handleProfileTap(isInitial: Bool) {
        let now = Date()
        if let lastTap = lastProfileTapTime, now.timeIntervalSince(lastTap) > 0.7 {
            profileTapCount = 0
        }
        lastProfileTapTime = now
        profileTapCount += 1

        if profileTapCount >= 7 {
            profileTapCount = 0
            onShowSelectServerHost?()
        }

        onProfileFlowSelect?(isInitial)
    }

    func viewLoaded() {
        // Fetch user role
        userService?.getMyUser(
        ).sink(receiveValue: { [weak self] result in
            switch result {
            case .success(let myUser):
                if myUser.isBanned {
                    self?.onProfileFlowSelect?(true)
                }
            case .failure:
                break
            }
        }).store(in: &cancellables)
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
