//
//  MyOffersViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol MyOffersViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func openOffer(_ id: Int)
}
