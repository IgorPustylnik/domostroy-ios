//
//  RequestCalendarViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 17/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import HorizonCalendar
import UIKit

protocol RequestCalendarViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func dismiss()
    func handleDaySelection(_ day: DayComponents)
    func handleDragDaySelection(_ day: DayComponents, _ gestureState: UIGestureRecognizer.State)
}
