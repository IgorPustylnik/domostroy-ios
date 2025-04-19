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
    let dates: ClosedRange<Date>
    let forbiddenDates: [Date]
    let selectedDates: DayComponentsRange?
}

protocol RequestCalendarModuleInput: AnyObject {
    func configure(with viewModel: RequestCalendarConfig)
}
