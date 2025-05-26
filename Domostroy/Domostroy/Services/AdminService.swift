//
//  AdminService.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 22.05.2025.
//

import Foundation
import Combine
import NodeKit

public protocol AdminService {

    func getUsers(
        searchQuery: String?,
        paginationEntity: PaginationRequestEntity
    ) -> AnyPublisher<NodeResult<Page1Entity<UserDetailsEntity>>, Never>

    func getOffers(
        searchRequestEntity: SearchRequestEntity
    ) -> AnyPublisher<NodeResult<PageEntity<BriefOfferAdminEntity>>, Never>

    func unbanOffer(id: Int) -> AnyPublisher<NodeResult<Void>, Never>

    func banOffer(banOfferEntity: BanOfferEntity) -> AnyPublisher<NodeResult<Void>, Never>

    func deleteOffer(id: Int) -> AnyPublisher<NodeResult<Void>, Never>

    func setUserBan(id: Int, value: Bool) -> AnyPublisher<NodeResult<Void>, Never>

    func deleteUser(id: Int) -> AnyPublisher<NodeResult<Void>, Never>

}
