//
//  CityNetworkService.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 04.05.2025.
//

import Combine
import NodeKit

public final class CityNetworkService: CityService {

    // MARK: - Properties

    private let secureStorage: SecureStorage

    // MARK: - Init

    init(secureStorage: SecureStorage) {
        self.secureStorage = secureStorage
    }

    // MARK: - GET

    public func getCities(query: String?) -> AnyPublisher<NodeResult<CitiesEntity>, Never> {
        if let query, !query.isEmpty {
            return makeBuilder()
                .route(.get, .base)
                .set(query: ["city": query])
                .encode(as: .urlQuery)
                .build()
                .nodeResultPublisher()
        } else {
            return makeBuilder()
                .route(.get, .popular)
                .build()
                .nodeResultPublisher()
        }
    }

    public func getCity(id: Int) -> AnyPublisher<NodeResult<CityEntity>, Never> {
        makeBuilder()
            .route(.get, .one(id))
            .build()
            .nodeResultPublisher()
            .map { (result: NodeResult<CitiesEntity>) in
                result.flatMap { cities in
                    if let first = cities.cities.first {
                        return .success(first)
                    } else {
                        return .failure(ResponseDataParserNodeError.cantCastDesirializedDataToJson(""))
                    }
                }
            }
            .eraseToAnyPublisher()

    }
}

// MARK: - Private methods

private extension CityNetworkService {
    func makeBuilder() -> URLChainBuilder<CityUrlRoute> {
        let token = secureStorage.loadToken()
        var builder = URLChainBuilder<CityUrlRoute>(serviceChainProvider: DURLServiceChainProvider())

        if let token {
            builder = builder.set(metadata: ["Authorization": "Bearer \(token.token)"])
        }

        return builder
    }
}
