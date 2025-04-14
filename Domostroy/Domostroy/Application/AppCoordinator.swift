//
//  AppCoordinator.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 02.04.2025.
//

import Foundation

enum OnboardingState {
    case notPassed
    case passed
}

enum UserState {
    case authorized
    case unauthorized
}

private enum LaunchInstructor {
    case onboarding
    case main

    static func configure(onboardingState: OnboardingState) -> LaunchInstructor {
        switch onboardingState {
        case .notPassed:
            return .onboarding
        case .passed:
            return .main
        }
    }
}

final class AppCoordinator: BaseCoordinator {

    // MARK: - Private Properties

    private var instructor: LaunchInstructor {
        // TODO: Get from UserDefaults
        let state = OnboardingState.passed
        return .configure(onboardingState: state)
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
