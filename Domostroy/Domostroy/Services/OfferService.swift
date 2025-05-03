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

    func getOffers(searchOffersEntity: SearchOffersEntity) -> AnyPublisher<NodeResult<PageEntity<BriefOfferEntity>>, Never>

    func getMyOffers(
        page: Int,
        perPage: Int
    ) -> AnyPublisher<NodeResult<PageEntity<MyOfferEntity>>, Never>

    func getFavoriteOffers(
        page: Int,
        perPage: Int,
        sort: SortViewModel?
    ) -> AnyPublisher<NodeResult<PageEntity<FavoriteOfferEntity>>, Never>

    // MARK: - POST

    func createOffer(createOfferEntity: CreateOfferEntity) -> AnyPublisher<NodeResult<OfferIdEntity>, Never>

    // MARK: - DELETE

    func deleteOffer(id: Int) -> AnyPublisher<NodeResult<Void>, Never>

}
