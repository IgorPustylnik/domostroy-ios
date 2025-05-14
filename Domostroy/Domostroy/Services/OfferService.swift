//
//  OfferService.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import Combine
import NodeKit

public protocol OfferService {

    // MARK: - GET

    func getOffer(
        id: Int
    ) -> AnyPublisher<NodeResult<OfferDetailsEntity>, Never>

    func getOffers(
        searchOffersEntity: SearchOffersEntity
    ) -> AnyPublisher<NodeResult<PageEntity<BriefOfferEntity>>, Never>

    func getMyOffers(
        paginationEntity: PaginationRequestEntity
    ) -> AnyPublisher<NodeResult<Page1Entity<MyOfferEntity>>, Never>

    func getFavoriteOffers(
        paginationEntity: PaginationRequestEntity,
        sortEntity: SortEntity?
    ) -> AnyPublisher<NodeResult<Page1Entity<FavoriteOfferEntity>>, Never>

    func getOfferCalendar(
        offerId: Int
    ) -> AnyPublisher<NodeResult<OfferCalendarEntity>, Never>

    // MARK: - POST

    func createOffer(createOfferEntity: CreateOfferEntity) -> AnyPublisher<NodeResult<OfferIdEntity>, Never>

    func toggleFavorite(id: Int) -> AnyPublisher<NodeResult<Void>, Never>

    // MARK: - DELETE

    func deleteOffer(id: Int) -> AnyPublisher<NodeResult<Void>, Never>

}
