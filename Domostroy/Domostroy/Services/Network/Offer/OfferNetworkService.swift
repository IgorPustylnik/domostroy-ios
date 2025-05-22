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

    public func getOffer(id: Int) -> AnyPublisher<NodeResult<OfferDetailsEntity>, Never> {
        return makeBuilder()
            .route(.get, .one(id))
            .build()
            .nodeResultPublisher()
    }

    public func getOffers(
        searchOffersEntity: SearchRequestEntity
    ) -> AnyPublisher<NodeResult<PageEntity<BriefOfferEntity>>, Never> {
        return makeBuilder()
            .route(.post, .search)
            .build()
            .nodeResultPublisher(for: searchOffersEntity)
    }

    public func getMyOffers(
        paginationEntity: PaginationRequestEntity
    ) -> AnyPublisher<NodeResult<Page1Entity<MyOfferEntity>>, Never> {
        var query: [String: Any] = [:]
        query["page"] = paginationEntity.page
        query["size"] = paginationEntity.size
        query["sort"] = "\(SortEntity.SortProperty.date.rawValue),\(SortEntity.SortDirection.descending.rawValue)"
        return makeBuilder()
            .route(.get, .my)
            .set(query: query)
            .build()
            .nodeResultPublisher()
    }

    public func getFavoriteOffers(
        paginationEntity: PaginationRequestEntity,
        sortEntity: SortEntity?
    ) -> AnyPublisher<NodeResult<Page1Entity<FavoriteOfferEntity>>, Never> {
        var query: [String: Any] = [:]
        query["page"] = paginationEntity.page
        query["size"] = paginationEntity.size
        if let sortEntity {
            query["sort"] = "\(sortEntity.property.rawValue),\(sortEntity.direction.rawValue)"
        }
        return makeBuilder()
            .route(.get, .favorites)
            .set(query: query)
            .build()
            .nodeResultPublisher()
    }

    public func getOfferCalendar(offerId: Int) -> AnyPublisher<NodeResult<OfferCalendarEntity>, Never> {
        makeBuilder()
            .route(.get, .calendar(offerId))
            .build()
            .nodeResultPublisher()
    }

    public func createOffer(createOfferEntity: CreateOfferEntity) -> AnyPublisher<NodeResult<OfferIdEntity>, Never> {
        return makeBuilder()
            .route(.post, .base)
            .build()
            .nodeResultPublisher(for: createOfferEntity)
    }

    public func setFavorite(id: Int, value: Bool) -> AnyPublisher<NodeResult<Void>, Never> {
        return makeBuilder()
            .route(.post, .favorite(id))
            .set(query: ["isFavourite": value])
            .build()
            .nodeResultPublisher()
    }

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
            builder = builder.set(metadata: ["Authorization": "Bearer \(token.token)"])
        }

        return builder
    }
}
