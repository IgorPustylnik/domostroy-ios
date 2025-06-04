//
//  AppCoordinator.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 02.04.2025.
//

import Foundation

private enum LaunchInstructor {
    case onboarding
    case main

    static func configure(passedOnboarding: Bool) -> LaunchInstructor {
        switch passedOnboarding {
        case false:
            return .onboarding
        case true:
            return .main
        }
    }
}

final class AppCoordinator: BaseCoordinator {

    // MARK: - Private Properties

    private var instructor: LaunchInstructor {
        let basicStorage: BasicStorage? = ServiceLocator.shared.resolve()
        guard let passed = basicStorage?.get(for: .passedOnboarding) else {
            return .configure(passedOnboarding: false)
        }
        return .configure(passedOnboarding: passed)
    }

    private var networkMonitor: NetworkMonitor? = ServiceLocator.shared.resolve()

    private lazy var router = MainRouter()

    // MARK: - Coordinator

    override func start() {
        switch instructor {
        case .onboarding:
            runOnboardingFlow()
        case .main:
            runMainFlow()
        }

        setupNetworkMonitor()
    }

}

// MARK: - Private Methods

private extension AppCoordinator {

    func runOnboardingFlow() {
        let coordinator = OnboardingCoordinator(router: router)
        coordinator.onComplete = { [weak self, weak coordinator] in
            self?.start()
            self?.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start()
    }

    func runMainFlow() {
        let coordinator = MainTabBarCoordinator(router: router)
        addDependency(coordinator)
        coordinator.start()
    }

    func setupNetworkMonitor() {
        networkMonitor?.onStatusChange = { [weak self] connected in
            DispatchQueue.main.async {
                guard !connected else {
                    NoInternetOverlayPresenter.shared.hide()
                    self?.networkMonitor?.start()
                    return
                }
                self?.networkMonitor?.stop()
                NoInternetOverlayPresenter.shared.show(
                    onRetry: { [weak self] in
                        NoInternetOverlayPresenter.shared.setLoading(true)

                        self?.networkMonitor?.checkConnection {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                NoInternetOverlayPresenter.shared.setLoading(false)
                            }
                        }
                    }
                )
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.networkMonitor?.start()
        }
    }

}
