//
//  LessorCalendarModuleInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 25/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation
import HorizonCalendar

struct LessorCalendarConfig {
    let dates: ClosedRange<Date>
    let forbiddenDates: [Date]
    let selectedDays: Set<Date>
}

protocol LessorCalendarModuleInput: AnyObject {
    func configure(with viewModel: LessorCalendarConfig)
    func setOfferId(_ id: Int)
}
