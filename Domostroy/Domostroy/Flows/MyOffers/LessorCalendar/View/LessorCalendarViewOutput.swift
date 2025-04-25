//
//  LessorCalendarViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 25/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import HorizonCalendar

protocol LessorCalendarViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func dismiss()
    func apply()
    func handleDaySelection(_ day: DayComponents)
    func handleDragDaySelection(_ day: DayComponents, _ gestureState: UIGestureRecognizer.State)
    func fillMonth(_ month: MonthComponents)
    func isMonthFullySelected(_ month: MonthComponents) -> Bool
}
