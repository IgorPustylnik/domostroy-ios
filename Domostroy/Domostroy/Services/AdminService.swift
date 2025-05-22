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
        query: String?,
        paginationEntity: PaginationRequestEntity
    ) -> AnyPublisher<NodeResult<PageEntity<UserDetailsEntity>>, Never>

    func setOfferBan(id: Int, reason: String?, value: Bool) -> AnyPublisher<NodeResult<Void>, Never>

    func deleteOffer(id: Int) -> AnyPublisher<NodeResult<Void>, Never>

    func setUserBan(id: Int, value: Bool) -> AnyPublisher<NodeResult<Void>, Never>

    func deleteUser(id: Int) -> AnyPublisher<NodeResult<Void>, Never>

}
