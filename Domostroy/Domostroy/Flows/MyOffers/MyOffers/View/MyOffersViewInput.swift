//
//  MyOffersViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol MyOffersViewInput: AnyObject, Loadable, EmptyStateable {
    /// Method for setup initial state of view
    func setupInitialState()
}
