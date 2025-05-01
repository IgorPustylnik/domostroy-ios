//
//  UserNetworkService.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 28.04.2025.
//

import Foundation
import Combine
import NodeKit

public final class UserNetworkService: UserService {

    // MARK: - Properties

    private let secureStorage: SecureStorage

    // MARK: - Init

    init(secureStorage: SecureStorage) {
        self.secureStorage = secureStorage
    }

    // MARK: - GET

    public func getUser(id: Int) -> AnyPublisher<NodeResult<UserEntity>, Never> {
        makeBuilder()
            .route(.get, .byId(id))
            .build()
            .nodeResultPublisher()
    }

    public func getMyUser() -> AnyPublisher<NodeResult<MyUserEntity>, Never> {
        makeBuilder()
            .route(.get, .my)
            .build()
            .nodeResultPublisher()
    }
}

// MARK: - Private methods

private extension UserNetworkService {
    func makeBuilder() -> URLChainBuilder<UserUrlRoute> {
        let token = secureStorage.loadToken()
        var builder = URLChainBuilder<UserUrlRoute>(serviceChainProvider: DURLServiceChainProvider())

        if let token {
            builder = builder.set(metadata: ["Authorization": "Bearer \(token.token)"])
        }

        return builder
    }
}
