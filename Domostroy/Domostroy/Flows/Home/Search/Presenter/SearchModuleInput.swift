//
//  SearchModuleInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 11/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol SearchModuleInput: AnyObject {
    func setQuery(_ query: String?)
    func setCity(_ city: City)
    func setSort(_ sort: Sort)
    func setFilter(_ filter: Filter)
}
