//
//  AuthCoordinator.swift
//  Domostroy
//
//  Created by igorpustylnik on 04/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class AuthCoordinator: BaseCoordinator, AuthCoordinatorOutput {

    // MARK: - AuthCoordinatorOutput

    // MARK: - Private Properties

    private let router: Router

    // MARK: - Initialization

    init(router: Router) {
        self.router = router
    }

    override func start() {
        showAuth()
    }

}

// MARK: - Private methods

private extension AuthCoordinator {

    func showAuth() {
        let (view, output) = AuthModuleConfigurator().configure()
        output.onLogin = { [weak self] in self?.showLogin() }
        output.onRegister = { [weak self] in self?.showRegister() }
        router.setNavigationControllerRootModule(view, animated: false, hideBar: false)
    }

    func showLogin() {
        let (view, output) = LoginModuleConfigurator().configure()
        router.push(view, animated: true)
    }

    func showRegister() {
        let (view, output) = RegisterModuleConfigurator().configure()
        output.onReceiveCode = { [weak self] registerDTO in
            self?.showCodeConfirmation(registerDTO: registerDTO)
        }
        router.push(view, animated: true)
    }

    func showCodeConfirmation(registerDTO: RegisterDTO) {
        let (view, output) = CodeConfirmationModuleConfigurator().configure(registerDTO: registerDTO)
        router.push(view, animated: true)
    }

}
