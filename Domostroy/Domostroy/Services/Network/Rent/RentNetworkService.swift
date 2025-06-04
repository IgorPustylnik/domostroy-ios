//
//  RentNetworkService.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 14.05.2025.
//

import Foundation
import Combine
import NodeKit

public final class RentNetworkService: RentService {

    // MARK: - Properties

    private let secureStorage: SecureStorage

    // MARK: - Init

    init(secureStorage: SecureStorage) {
        self.secureStorage = secureStorage
    }

    // MARK: - GET

    public func getOutgoingRequests(
        paginationEntity: PaginationRequestEntity
    ) -> AnyPublisher<NodeResult<Page1Entity<RentalRequestEntity>>, Never> {
        makeBuilder()
            .route(.get, .outgoingRequests(page: paginationEntity.page, size: paginationEntity.size))
            .build()
            .nodeResultPublisher()
    }

    public func getIncomingRequests(
        paginationEntity: PaginationRequestEntity
    ) -> AnyPublisher<NodeResult<Page1Entity<RentalRequestEntity>>, Never> {
        makeBuilder()
            .route(.get, .incomingRequests(page: paginationEntity.page, size: paginationEntity.size))
            .build()
            .nodeResultPublisher()
    }

    public func getOutgoingRequest(id: Int) -> AnyPublisher<NodeResult<RentalRequest1Entity>, Never> {
        makeBuilder()
            .route(.get, .outgoingRequest(id))
            .build()
            .nodeResultPublisher()
    }

    public func getIncomingRequest(id: Int) -> AnyPublisher<NodeResult<RentalRequest1Entity>, Never> {
        makeBuilder()
            .route(.get, .incomingRequest(id))
            .build()
            .nodeResultPublisher()
    }

    // MARK: - POST

    public func createRentRequest(createRequestEntity: CreateRequestEntity) -> AnyPublisher<NodeResult<Void>, Never> {
        makeBuilder()
            .route(.post, .base)
            .build()
            .nodeResultPublisher(for: createRequestEntity)
    }

    // MARK: - PATCH

    public func changeRequestStatus(id: Int, status: RequestStatus) -> AnyPublisher<NodeResult<Void>, Never> {
        makeBuilder()
            .route(.patch, .one(id))
            .set(query: [
                "status": status.rawValue
            ])
            .build()
            .nodeResultPublisher()
    }

    // MARK: - DELETE

    public func deleteRentRequest(id: Int) -> AnyPublisher<NodeResult<Void>, Never> {
        makeBuilder()
            .route(.delete, .one(id))
            .build()
            .nodeResultPublisher()
    }

}

// MARK: - Private methods

private extension RentNetworkService {
    func makeBuilder() -> URLChainBuilder<RentUrlRoute> {
        let token = secureStorage.loadToken()
        var builder = URLChainBuilder<RentUrlRoute>(serviceChainProvider: DURLServiceChainProvider())

        if let token {
            builder = builder.set(metadata: ["Authorization": "Bearer \(token.token)"])
        }

        return builder
    }
}
