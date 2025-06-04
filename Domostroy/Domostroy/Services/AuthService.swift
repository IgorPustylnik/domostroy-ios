//
//  AuthService.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 28.04.2025.
//

import Foundation
import Combine
import NodeKit

public protocol AuthService {

    // MARK: - POST

    func postLogin(
        loginEntity: LoginEntity
    ) -> AnyPublisher<NodeResult<AuthTokenEntity>, Never>

    func postRegister(
        registerEntity: RegisterEntity
    ) -> AnyPublisher<NodeResult<Void>, Never>

    func postConfirmRegister(
        confirmRegisterEntity: ConfirmRegisterEntity
    ) -> AnyPublisher<NodeResult<Void>, Never>

}
