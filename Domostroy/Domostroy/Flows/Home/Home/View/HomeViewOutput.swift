//
//  HomeViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol HomeViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func setSearch(active: Bool)
    func search(query: String?)
    func openOffer(_ id: Int)
}
