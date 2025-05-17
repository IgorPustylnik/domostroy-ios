//
//  DropsPresenter.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 01.05.2025.
//

import UIKit
import Drops
import NodeKit

protocol InfoPresenter {
    func showSuccess(title: String?, subtitle: String?, image: UIImage?)

    func showWarning(title: String?, subtitle: String?, image: UIImage?)

    func showError(title: String?, error: Error, image: UIImage?)
    func showError(title: String?, subtitle: String?, image: UIImage?)
}

final class DropsPresenter: InfoPresenter {
    static let shared = DropsPresenter()

    private init() {}

    private lazy var feedbackGenerator = UINotificationFeedbackGenerator()

    // MARK: - Public methods

    func showSuccess(
        title: String? = nil,
        subtitle: String? = nil,
        image: UIImage? = UIImage(systemName: "checkmark")
    ) {
        let drop = Drop(
            title: title ?? L10n.Localizable.Common.success,
            titleNumberOfLines: 1,
            subtitle: subtitle,
            subtitleNumberOfLines: 0,
            icon: image
        )
        feedbackGenerator.notificationOccurred(.success)
        Drops.show(drop)
    }

    func showWarning(
        title: String?,
        subtitle: String?,
        image: UIImage? = UIImage(
            systemName: "exclamationmark.triangle"
        )
    ) {
        let drop = Drop(
            title: title ?? L10n.Localizable.Common.warning,
            titleNumberOfLines: 1,
            subtitle: subtitle,
            subtitleNumberOfLines: 0,
            icon: image
        )
        feedbackGenerator.notificationOccurred(.warning)
        Drops.show(drop)
    }

    func showError(title: String? = nil, subtitle: String? = nil, image: UIImage? = UIImage(systemName: "xmark")) {
        let drop = Drop(
            title: title ?? L10n.Localizable.Common.error,
            titleNumberOfLines: 1,
            subtitle: subtitle,
            subtitleNumberOfLines: 0,
            icon: image
        )
        feedbackGenerator.notificationOccurred(.error)
        Drops.show(drop)
    }

    func showError(
        title: String? = nil,
        error: Error,
        image: UIImage? = UIImage(systemName: "xmark")
    ) {
        var subtitle: String?
        if let httpError = error as? ResponseHttpErrorProcessorNodeError {
            subtitle = httpError.fancyDescription()
        } else if let parseError = error as? ResponseDataParserNodeError {
            subtitle = L10n.Localizable.ParseError.cantDeserialize
        } else if let baseTechnicalError = error as? BaseTechnicalError {
            subtitle = baseTechnicalError.fancyDescription()
        } else {
            subtitle = error.localizedDescription
        }
        showError(title: title, subtitle: subtitle, image: image)
    }

}

// MARK: - Errors descriptions extensions

extension ResponseHttpErrorProcessorNodeError {
    func fancyDescription() -> String {
        var description: String
        switch self {
        case .badRequest:
            description = L10n.Localizable.HttpError.badRequest
        case .unauthorized:
            description = L10n.Localizable.HttpError.unauthorized
        case .forbidden:
            description = L10n.Localizable.HttpError.forbidden
        case .notFound:
            description = L10n.Localizable.HttpError.notFound
        case .internalServerError:
            description = L10n.Localizable.HttpError.internalServerError
        }
        return description
    }
}

extension BaseTechnicalError {
    func fancyDescription() -> String {
        var description: String
        switch self {
        case .noInternetConnection:
            description = L10n.Localizable.BaseTechnicalError.noInternet
        case .dataNotAllowed:
            description = L10n.Localizable.BaseTechnicalError.dataNotAllowed
        case .timeout:
            description = L10n.Localizable.BaseTechnicalError.timeout
        case .cantConnectToHost:
            description = L10n.Localizable.BaseTechnicalError.cantConnectToHost
        }
        return description
    }
}
