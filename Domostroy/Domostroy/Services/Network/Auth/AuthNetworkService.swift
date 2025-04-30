//
//  AuthNetworkService.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 29.04.2025.
//

import Foundation
import Combine
import NodeKit

public final class AuthNetworkService: AuthService {

    // MARK: - Properties

    private var builder: URLChainBuilder<AuthUrlRoute> {
        .init()
    }

    // MARK: - POST

    public func postLogin(loginEntity: LoginEntity) -> AnyPublisher<NodeResult<AuthTokenEntity>, Never> {
        builder
            .route(.post, .login)
            .build()
            .nodeResultPublisher(for: loginEntity)
    }

    public func postRegister(registerEntity: RegisterEntity) -> AnyPublisher<NodeResult<Void>, Never> {
        builder
            .route(.post, .register)
            .build()
            .nodeResultPublisher(for: registerEntity)
    }

    public func postConfirmRegister(
        confirmRegisterEntity: ConfirmRegisterEntity
    ) -> AnyPublisher<NodeResult<Void>, Never> {
        builder
            .route(.post, .confirmRegister)
            .build()
            .nodeResultPublisher(for: confirmRegisterEntity)
    }

}
