//
//  AdminPanelPresenterModel.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 21.05.2025.
//

enum AdminPanelPresenterModel {
    enum Segment: Int, CaseIterable {
        case users
        case bannedOffers

        var description: String {
            switch self {
            case .users:
                return L10n.Localizable.AdminPanel.Users.title
            case .bannedOffers:
                return L10n.Localizable.AdminPanel.BannedOffers.title
            }
        }
    }
}
