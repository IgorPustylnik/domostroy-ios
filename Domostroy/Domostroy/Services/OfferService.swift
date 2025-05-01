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
    ) -> AnyPublisher<NodeResult<OfferEntity>, Never>

    func getOffers(
        page: Int,
        perPage: Int,
        searchQuery: String?,
        category: CategoryEntity?,
        sort: Sort?
    ) -> AnyPublisher<NodeResult<OffersPageEntity>, Never>

    func getMyOffers(
        page: Int,
        perPage: Int
    ) -> AnyPublisher<NodeResult<OffersPageEntity>, Never>

    func getFavoriteOffers(
        page: Int,
        perPage: Int,
        sort: Sort?
    ) -> AnyPublisher<NodeResult<OffersPageEntity>, Never>

    // MARK: - POST

    func createOffer(createOfferEntity: CreateOfferEntity) -> AnyPublisher<NodeResult<OfferIdEntity>, Never>

    // MARK: - DELETE

    func deleteOffer(id: Int) -> AnyPublisher<NodeResult<Void>, Never>

}
