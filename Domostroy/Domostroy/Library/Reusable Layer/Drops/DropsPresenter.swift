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
        var title = title
        if let httpError = error as? DResponseHttpErrorProcessorNodeError {
            title = httpError.userFriendlyDescription()
        } else if error is ResponseDataParserNodeError {
            title = L10n.Localizable.UserFriendlyError.somethingWentWrong
        } else if let baseTechnicalError = error as? BaseTechnicalError {
            title = baseTechnicalError.userFriendlyDescription()
        }

        showError(title: title, subtitle: nil, image: image)
    }

}
