//
//  ErrorsDescriptions.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 31.05.2025.
//

import NodeKit

extension DResponseHttpErrorProcessorNodeError {
    func userFriendlyDescription() -> String {
        var description: String
        switch self {
        case .badRequest:
            description = L10n.Localizable.UserFriendlyError.somethingWentWrong
        case .unauthorized:
            description = L10n.Localizable.UserFriendlyError.noPermission
        case .forbidden:
            description = L10n.Localizable.UserFriendlyError.somethingWentWrong
        case .notFound:
            description = L10n.Localizable.UserFriendlyError.noPermission
        case .conflict:
            description = L10n.Localizable.UserFriendlyError.somethingWentWrong
        case .internalServerError:
            description = L10n.Localizable.UserFriendlyError.somethingWentWrong
        }
        return description
    }
}

extension BaseTechnicalError {
    func userFriendlyDescription() -> String {
        var description: String
        switch self {
        case .noInternetConnection:
            description = L10n.Localizable.UserFriendlyError.noInternet
        case .dataNotAllowed:
            description = L10n.Localizable.UserFriendlyError.somethingWentWrong
        case .timeout:
            description = L10n.Localizable.UserFriendlyError.serverNotResponding
        case .cantConnectToHost:
            description = L10n.Localizable.UserFriendlyError.serverNotResponding
        }
        return description
    }
}
