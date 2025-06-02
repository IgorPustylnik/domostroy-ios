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
        overlay.view.alpha = 0
        overlay.retryButton.setAction { onRetry?() }

        overlayWindow.rootViewController = overlay
        overlayWindow.isHidden = false

        self.window = overlayWindow
        self.overlayViewController = overlay

        UIView.animate(withDuration: 0.5) {
            overlay.view.alpha = 1
        }
    }

    func setLoading(_ isLoading: Bool) {
        overlayViewController?.retryButton.setLoading(isLoading)
    }

    func hide() {
        UIView.animate(
            withDuration: 0.5,
            animations: {
                self.overlayViewController?.view.alpha = 0
            }, completion: { _ in
                self.window?.isHidden = true
                self.window = nil
                self.overlayViewController = nil
            }
        )
    }
}
