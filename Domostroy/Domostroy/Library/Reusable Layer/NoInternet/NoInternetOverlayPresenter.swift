//
//  NoInternetOverlayPresenter.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 01.06.2025.
//

import UIKit

final class NoInternetOverlayPresenter {

    // MARK: - Properties

    static let shared = NoInternetOverlayPresenter()

    private var window: UIWindow?
    private var overlayViewController: NoInternetOverlayViewController?

    private init() {}

    // MARK: - Public methods

    func show(onRetry: EmptyClosure? = nil) {
        guard window == nil else {
            return
        }

        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
            return
        }

        let overlayWindow = UIWindow(windowScene: windowScene)
        overlayWindow.windowLevel = .alert + 1
        overlayWindow.backgroundColor = .clear

        let overlay = NoInternetOverlayViewController()
        overlay.retryButton.setAction { onRetry?() }

        overlayWindow.rootViewController = overlay
        overlayWindow.isHidden = false

        self.window = overlayWindow
        self.overlayViewController = overlay
    }

    func setLoading(_ isLoading: Bool) {
        overlayViewController?.retryButton.setLoading(isLoading)
    }

    func hide() {
        window?.isHidden = true
        window = nil
        overlayViewController = nil
    }
}
