//
//  RequestCalendarModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 17/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import HorizonCalendar

protocol RequestCalendarModuleOutput: AnyObject {
    var onDismiss: EmptyClosure? { get set }
    var onApply: ((DayComponentsRange?) -> Void)? { get set }
}
