//
//  RequestCalendarModuleInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 17/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation
import HorizonCalendar

struct RequestCalendarConfig {
    let offerId: Int
    let selectedDates: DayComponentsRange?
    let price: PriceEntity
}

protocol RequestCalendarModuleInput: AnyObject {
    func configure(with viewModel: RequestCalendarConfig)
}
