//
//  CityService.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 04.05.2025.
//

import Combine
import NodeKit

public protocol CityService {

    func getCities(query: String?) -> AnyPublisher<NodeResult<CitiesEntity>, Never>

    func getCity(id: Int) -> AnyPublisher<NodeResult<CityEntity>, Never>
}
