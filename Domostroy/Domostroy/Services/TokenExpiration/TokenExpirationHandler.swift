//
//  TokenExpirationHandler.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 30.04.2025.
//

import Foundation

final class TokenExpirationHandler {

    // MARK: - Properties

    private var timer: Timer?
    private let secureStorage: SecureStorage? = ServiceLocator.shared.resolve()
    var onExpire: (() -> Void)?

    // MARK: - Public methods

    func scheduleExpiration(for token: AuthTokenEntity) {
        timer?.invalidate()

        let interval = token.expiresAt.timeIntervalSinceNow
        guard interval > 0 else {
            expireNow()
            return
        }

        timer = Timer.scheduledTimer(
            withTimeInterval: interval,
            repeats: false
        ) { [weak self] _ in
            self?.expireNow()
        }
    }

    func cancel() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Private methods

    private func expireNow() {
        secureStorage?.deleteToken()
        onExpire?()
    }
}
