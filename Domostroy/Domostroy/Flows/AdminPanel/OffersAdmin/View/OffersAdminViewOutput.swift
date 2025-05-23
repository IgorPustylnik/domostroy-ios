//
//  OffersAdminViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 23/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol OffersAdminViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func openOffer(_ id: Int)
}
