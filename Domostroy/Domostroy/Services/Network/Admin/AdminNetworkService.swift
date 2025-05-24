//
//  AdminNetworkService.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 22.05.2025.
//

import Foundation
import Combine
import NodeKit

final class AdminNetworkService: AdminService {

    // MARK: - Properties

    private let secureStorage: SecureStorage

    // MARK: - Init

    init(secureStorage: SecureStorage) {
        self.secureStorage = secureStorage
    }

    func getUsers(
        query: String?,
        paginationEntity: PaginationRequestEntity
    ) -> AnyPublisher<NodeResult<PageEntity<UserDetailsEntity>>, Never> {
        var query: [String: Any] = [:]
        query["page"] = paginationEntity.page
        query["size"] = paginationEntity.size
        query["query"] = query
        return makeBuilder()
            .route(.get, .users)
            .set(query: query)
            .build()
            .nodeResultPublisher()
    }

    func setOfferBan(id: Int, reason: String?, value: Bool) -> AnyPublisher<NodeResult<Void>, Never> {
        var query: [String: Any] = [:]
        query["id"] = id
        if let reason {
            query["reason"] = reason
        }
        query["banned"] = value
        return makeBuilder()
            .route(.get, .banOffer)
            .set(query: query)
            .encode(as: .json)
            .build()
            .nodeResultPublisher()
    }

    func deleteOffer(id: Int) -> AnyPublisher<NodeResult<Void>, Never> {
        makeBuilder()
            .route(.delete, .offer(id))
            .build()
            .nodeResultPublisher()
    }

    func setUserBan(id: Int, value: Bool) -> AnyPublisher<NodeResult<Void>, Never> {
        var query: [String: Any] = [:]
        query["id"] = id
        query["banned"] = value
        return makeBuilder()
            .route(.post, .banUser)
            .build()
            .nodeResultPublisher()
    }

    func deleteUser(id: Int) -> AnyPublisher<NodeResult<Void>, Never> {
        makeBuilder()
            .route(.delete, .user(id))
            .build()
            .nodeResultPublisher()
    }

}

// MARK: - Private methods

private extension AdminNetworkService {
    func makeBuilder() -> URLChainBuilder<AdminUrlRoute> {
        let token = secureStorage.loadToken()
        var builder = URLChainBuilder<AdminUrlRoute>(serviceChainProvider: DURLServiceChainProvider())
        if let token {
            builder = builder.set(metadata: ["Authorization": "Bearer \(token.token)"])
        }
        return builder
    }
}
