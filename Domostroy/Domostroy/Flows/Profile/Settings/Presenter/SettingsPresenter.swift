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

    var onDismiss: EmptyClosure?

    // MARK: - Properties

    weak var view: SettingsViewInput?

    private let userService: UserService? = ServiceLocator.shared.resolve()
    private var cancellables: Set<AnyCancellable> = .init()
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
    func loadSettings() {
        view?.setLoading(true)
        fetchSettings { [weak self] in
            self?.view?.setLoading(false)
        } handleResult: { [weak self] result in
            switch result {
            case .success(let settings):
                self?.setupWith(settings: settings)
            case .failure(let error):
                DropsPresenter.shared.showError(error: error)
                self?.onDismiss?()
            }
        }
    }

    func setupWith(settings: NotificationsSettingsEntity) {
        view?.configure(
            with: .init(
                notifications: .init(
                    initialState: settings.notificationsEnabled,
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

    func changeNotifications(enabled: Bool, completion: ((Bool) -> Void)?) {
        userService?.setNotifications(
            enabled: enabled
        ).sink(
            receiveValue: { result in
                switch result {
                case .success:
                    completion?(true)
                case .failure(let error):
                    DropsPresenter.shared.showError(error: error)
                    completion?(false)
                }
            }
        ).store(in: &cancellables)
    }

    func fetchSettings(completion: EmptyClosure?, handleResult: ((NodeResult<NotificationsSettingsEntity>) -> Void)?) {
        userService?.getNotificationsSettings(
        ).sink(
            receiveCompletion: { _ in completion?() },
            receiveValue: { handleResult?($0) }
        ).store(in: &cancellables)
    }

}
