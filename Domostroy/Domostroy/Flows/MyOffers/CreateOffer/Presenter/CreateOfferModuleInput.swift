//
//  CreateOfferModuleInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 15/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation

protocol CreateOfferModuleInput: AnyObject, CitySettable {
    func setSelectedDates(_ dates: Set<Date>)
}

protocol CitySettable: AnyObject {
    func setCity(_ city: CityEntity?)
}
