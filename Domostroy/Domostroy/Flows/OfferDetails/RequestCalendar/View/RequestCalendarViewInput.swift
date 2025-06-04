//
//  RequestCalendarViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 17/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import HorizonCalendar
import Foundation

struct RequestCalendarViewConfig {
    let calendar: Calendar
    let selectedDayRange: DayComponentsRange?
    let dates: ClosedRange<Date>
    let dayDateFormatter: DateFormatter
    let forbiddenDates: any Collection<Date>
    let overlaidItemLocations: Set<OverlaidItemLocation>
    let info: String?
}

protocol RequestCalendarViewInput: AnyObject, Loadable {
    func setupInitialState()
    func setupCalendar(config: RequestCalendarViewConfig)
}
