//
//  CategoryNetworkService.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 04.05.2025.
//

import Combine
import NodeKit

public final class CategoryNetworkService: CategoryService {

    // MARK: - Properties

    private let secureStorage: SecureStorage

    // MARK: - Init

    init(secureStorage: SecureStorage) {
        self.secureStorage = secureStorage
    }

    // MARK: - GET

    public func getCategories(query: String) -> AnyPublisher<NodeResult<CategoriesEntity>, Never> {
        makeBuilder()
            .route(.get, .base)
            .build()
            .nodeResultPublisher()
    }

}

// MARK: - Private methods

private extension CategoryNetworkService {
    func makeBuilder() -> URLChainBuilder<CategoryUrlRoute> {
        let token = secureStorage.loadToken()
        var builder = URLChainBuilder<CategoryUrlRoute>(serviceChainProvider: DURLServiceChainProvider())

        if let token {
            builder = builder.set(metadata: ["Authorization": "Bearer \(token.token)"])
        }

        return builder
    }
}
