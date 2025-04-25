//
//  CreateOfferViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 15/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol CreateOfferViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func create(details: CreateOfferDetails)
    func showCalendar()
    func close()
}
