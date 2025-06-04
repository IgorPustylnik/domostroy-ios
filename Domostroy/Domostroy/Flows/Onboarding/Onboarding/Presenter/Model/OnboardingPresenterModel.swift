//
//  OnboardingPresenterModel.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 31.05.2025.
//

import Foundation

struct OnboardingPresenterModel {
    let pages: [OnboardingPageModel] = [
        OnboardingPageModel(
            id: 0,
            title: L10n.Localizable.Onboarding.Page1.title,
            description: L10n.Localizable.Onboarding.Page1.description,
            image: .Onboarding.onboarding1
        ),
        OnboardingPageModel(
            id: 1,
            title: L10n.Localizable.Onboarding.Page2.title,
            description: L10n.Localizable.Onboarding.Page2.description,
            image: .Onboarding.onboarding2
        ),
        OnboardingPageModel(
            id: 2,
            title: L10n.Localizable.Onboarding.Page3.title,
            description: L10n.Localizable.Onboarding.Page3.description,
            image: .Onboarding.onboarding3
        )
    ]

    enum Buttons {
        case next
        case explore

        var title: String {
            switch self {
            case .next:
                L10n.Localizable.Onboarding.Button.next
            case .explore:
                L10n.Localizable.Onboarding.Button.explore
            }
        }
    }
}
