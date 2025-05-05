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

    func getCategories() -> AnyPublisher<NodeResult<CategoriesEntity>, Never>

}
