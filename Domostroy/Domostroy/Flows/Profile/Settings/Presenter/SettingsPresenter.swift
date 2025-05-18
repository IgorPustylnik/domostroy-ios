//
//  SettingsPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 18/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation
import Combine
import NodeKit
import UIKit

final class SettingsPresenter: SettingsModuleOutput {

    // MARK: - SettingsModuleOutput

    // MARK: - Properties

    weak var view: SettingsViewInput?
}

// MARK: - SettingsModuleInput

extension SettingsPresenter: SettingsModuleInput {

}

// MARK: - SettingsViewOutput

extension SettingsPresenter: SettingsViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
        loadSettings()
    }

}

// MARK: - Private methods

private extension SettingsPresenter {
    // TODO: Load from backend
    func loadSettings() {
        view?.setLoading(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
            self?.view?.setLoading(false)
            self?.view?.configure(
                with: .init(
                    notifications: .init(
                        initialState: false,
                        color: .systemRed,
                        image: UIImage(systemName: "bell.badge.fill"),
                        title: L10n.Localizable.Settings.Notifications.title,
                        toggleAction: { [weak self] value, handler in
                            self?.changeNotifications(enabled: value, completion: { success in
                                handler?(success)
                            })
                        }
                    )
                )
            )
        }
    }

    // TODO: Change on backend
    func changeNotifications(enabled: Bool, completion: ((Bool) -> Void)?) {
        completion?(true)
    }

}
