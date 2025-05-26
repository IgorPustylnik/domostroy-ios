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
        searchQuery: String?,
        paginationEntity: PaginationRequestEntity
    ) -> AnyPublisher<NodeResult<Page1Entity<UserDetailsEntity>>, Never> {
        var query: [String: Any] = [:]
        query["page"] = paginationEntity.page
        query["size"] = paginationEntity.size
        query["query"] = searchQuery ?? ""
        return makeBuilder()
            .route(.get, .users)
            .set(query: query)
            .build()
            .nodeResultPublisher()
    }

    func getOffers(
        searchRequestEntity: SearchRequestEntity
    ) -> AnyPublisher<NodeResult<PageEntity<BriefOfferAdminEntity>>, Never> {
        makeBuilder()
            .route(.post, .offers)
            .build()
            .nodeResultPublisher(for: searchRequestEntity)
    }

    func banOffer(banOfferEntity: BanOfferEntity) -> AnyPublisher<NodeResult<Void>, Never> {
        return makeBuilder()
            .route(.post, .banOffer)
            .build()
            .nodeResultPublisher(for: banOfferEntity)
    }

    func unbanOffer(id: Int) -> AnyPublisher<NodeResult<Void>, Never> {
        makeBuilder()
            .route(.post, .unbanOffer(id))
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
        query["isBanned"] = value
        return makeBuilder()
            .route(.post, .banUser(id))
            .set(query: query)
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
