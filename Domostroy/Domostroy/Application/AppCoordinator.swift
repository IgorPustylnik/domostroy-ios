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
            // TODO: Return false
            return .configure(passedOnboarding: true)
        }
        return .configure(passedOnboarding: passed)
    }

    // MARK: - Coordinator

    override func start() {
        switch instructor {
        case .onboarding:
            runOnboardingFlow()
        case .main:
            runMainFlow()
        }
    }

}

// MARK: - Private Methods

private extension AppCoordinator {

    // TODO: Implement
    func runOnboardingFlow() {
    }

    func runMainFlow() {
        let router = MainRouter()
        let coordinator = MainTabBarCoordinator(router: router)
        addDependency(coordinator)
        coordinator.start()
    }

}
