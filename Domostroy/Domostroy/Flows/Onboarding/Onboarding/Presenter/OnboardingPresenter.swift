//
//  OnboardingPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 31/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

final class OnboardingPresenter: OnboardingModuleOutput {

    // MARK: - OnboardingModuleOutput

    var onComplete: EmptyClosure?

    // MARK: - Properties

    weak var view: OnboardingViewInput?

    private let basicStorage: BasicStorage? = ServiceLocator.shared.resolve()

    private var model = OnboardingPresenterModel()
    private var currentPage = 0
    private var isLastPage: Bool {
        currentPage >= model.pages.count - 1
    }

    deinit {
        onComplete?()
    }
}

// MARK: - OnboardingModuleInput

extension OnboardingPresenter: OnboardingModuleInput {

}

// MARK: - OnboardingViewOutput

extension OnboardingPresenter: OnboardingViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
        view?.fillPages(with: model.pages)
        view?.setPage(index: currentPage, isLast: isLastPage)
    }

    func next() {
        guard !isLastPage else {
            completeOnboarding()
            return
        }
        currentPage += 1
        view?.setPage(index: currentPage, isLast: isLastPage)
    }

    func setPage(index: Int) {
        currentPage = index
        view?.setPage(index: currentPage, isLast: isLastPage)
    }

}

// MARK: - Private methods

private extension OnboardingPresenter {
    func completeOnboarding() {
        basicStorage?.set(true, for: .passedOnboarding)
        onComplete?()
    }
}
