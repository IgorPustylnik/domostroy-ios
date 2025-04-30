//
//  OfferNetworkService.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import Combine
import NodeKit

public final class OfferNetworkService: OfferService {

    // MARK: - Properties

    private let secureStorage: SecureStorage

    // MARK: - Init

    init(secureStorage: SecureStorage) {
        self.secureStorage = secureStorage
    }

    // MARK: - GET

    public func getOffer(id: Int) -> AnyPublisher<NodeResult<OfferEntity>, Never> {
        return makeBuilder()
            .route(.get, .one(id))
            .build()
            .nodeResultPublisher()
    }

    public func getOffers(
        page: Int,
        perPage: Int,
        searchQuery: String?,
        category: CategoryEntity?,
        sort: Sort?
    ) -> AnyPublisher<NodeResult<OffersPageEntity>, Never> {
        return makeBuilder()
            .route(.get, .search)
            .encode(as: .json)
            .build()
            .nodeResultPublisher()
    }

    public func getMyOffers(
        page: Int,
        perPage: Int
    ) -> AnyPublisher<NodeResult<OffersPageEntity>, Never> {
        return makeBuilder()
            .route(.get, .my)
            .encode(as: .json)
            .build()
            .nodeResultPublisher()
    }

    public func getFavoriteOffers(
        page: Int,
        perPage: Int,
        sort: Sort?
    ) -> AnyPublisher<NodeResult<OffersPageEntity>, Never> {
        return makeBuilder()
            .route(.get, .favorite)
            .encode(as: .json)
            .build()
            .nodeResultPublisher()
    }

    // MARK: - POST

    public func createOffer(createOfferEntity: CreateOfferEntity) -> AnyPublisher<NodeResult<OfferEntity>, Never> {
        return makeBuilder()
            .route(.post, .search)
            .build()
            .nodeResultPublisher(for: createOfferEntity)
    }

    // MARK: - DELETE

    public func deleteOffer(id: Int) -> AnyPublisher<NodeResult<Void>, Never> {
        return makeBuilder()
            .route(.delete, .one(id))
            .build()
            .nodeResultPublisher()
    }
}

// MARK: - Private methods

private extension OfferNetworkService {
    func makeBuilder() -> URLChainBuilder<OfferUrlRoute> {
        let token = secureStorage.loadToken()
        var builder = URLChainBuilder<OfferUrlRoute>(serviceChainProvider: DURLServiceChainProvider())

        if let token {
            builder = builder.set(metadata: ["Authorization": "Bearer \(token)"])
        }

        return builder
    }
}
