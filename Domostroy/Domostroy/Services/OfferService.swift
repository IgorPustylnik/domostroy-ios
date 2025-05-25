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

    func getOffer(
        id: Int
    ) -> AnyPublisher<NodeResult<OfferDetailsEntity>, Never>

    func getOffers(
        searchOffersEntity: SearchRequestEntity
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

    func editOfferCalendar(
        editOfferCalendarEntity: EditOfferCalendarEntity
    ) -> AnyPublisher<NodeResult<Void>, Never>

    func createOffer(createOfferEntity: CreateOfferEntity) -> AnyPublisher<NodeResult<OfferIdEntity>, Never>

    func editOffer(editOfferEntity: EditOfferEntity) -> AnyPublisher<NodeResult<NothingEntity>, Never>

    func setFavorite(id: Int, value: Bool) -> AnyPublisher<NodeResult<Void>, Never>

    func deleteOffer(id: Int) -> AnyPublisher<NodeResult<Void>, Never>

}
