//
//  LessorCalendarViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 25/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation
import HorizonCalendar

struct LessorCalendarViewConfig {
    let calendar: Calendar
    let dates: ClosedRange<Date>
    let selectedDays: Set<DayComponents>
    let dayDateFormatter: DateFormatter
    let forbiddenDates: any Collection<Date>
    let overlaidItemLocations: Set<OverlaidItemLocation>
}

protocol LessorCalendarViewInput: AnyObject {
    func setupCalendar(config: LessorCalendarViewConfig)
}
