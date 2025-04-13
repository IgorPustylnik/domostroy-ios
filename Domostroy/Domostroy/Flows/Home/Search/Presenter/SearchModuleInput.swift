//
//  SearchModuleInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 11/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol SearchModuleInput: AnyObject {
    func set(query: String?)
    func set(city: City)
    func set(sort: Sort)
    func set(filter: Filter)
}
