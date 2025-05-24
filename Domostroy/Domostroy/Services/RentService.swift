//
//  RentService.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 14.05.2025.
//

import Foundation
import Combine
import NodeKit

public protocol RentService {

    // MARK: - GET

    func getOutgoingRequests(
        paginationEntity: PaginationRequestEntity
    ) -> AnyPublisher<NodeResult<Page1Entity<RentalRequestEntity>>, Never>

    func getIncomingRequests(
        paginationEntity: PaginationRequestEntity
    ) -> AnyPublisher<NodeResult<Page1Entity<RentalRequestEntity>>, Never>

    func getOutgoingRequest(id: Int) -> AnyPublisher<NodeResult<RentalRequest1Entity>, Never>

    func getIncomingRequest(id: Int) -> AnyPublisher<NodeResult<RentalRequest1Entity>, Never>

    // MARK: - POST

    func createRentRequest(createRequestEntity: CreateRequestEntity) -> AnyPublisher<NodeResult<Void>, Never>

    // MARK: - PATCH

    func changeRequestStatus(id: Int, status: RequestStatus) -> AnyPublisher<NodeResult<Void>, Never>

    // MARK: - DELETE

    func deleteRentRequest(id: Int) -> AnyPublisher<NodeResult<Void>, Never>

}
