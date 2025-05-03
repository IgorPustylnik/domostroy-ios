//
//  CategoryService.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 04.05.2025.
//

import Foundation
import Combine
import NodeKit

public protocol CategoryService {

    func getCategories(query: String) -> AnyPublisher<NodeResult<CategoriesEntity>, Never>

}
