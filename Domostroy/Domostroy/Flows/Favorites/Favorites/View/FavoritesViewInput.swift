//
//  FavoritesViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol FavoritesViewInput: EmptyStateable, AnyObject {
    /// Method for setup initial state of view
    func setupInitialState()
    func setLoading(_ isLoading: Bool)
    func setSort(_ sort: String?)
}
