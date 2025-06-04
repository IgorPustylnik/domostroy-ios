//
//  MainTab.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 03.04.2025.
//

import UIKit

enum MainTab: Int, CaseIterable {

    case home
    case favorites
    case myOffers
    case requests
    case profile

    // MARK: - Properties

    var image: UIImage {
        switch self {
        case .home:
            return .MainTabBar.home
        case .favorites:
            return .MainTabBar.favorites
        case .myOffers:
            return .MainTabBar.myOffers
        case .requests:
            return .MainTabBar.requests
        case .profile:
            return .MainTabBar.profile
        }
    }

    var selectedImage: UIImage {
        switch self {
        case .home:
            return .MainTabBar.homeSelected
        case .favorites:
            return .MainTabBar.favoritesSelected
        case .myOffers:
            return .MainTabBar.myOffersSelected
        case .requests:
            return .MainTabBar.requestsSelected
        case .profile:
            return .MainTabBar.profileSelected
        }
    }

}
