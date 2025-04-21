//
//  CreateRequestModuleInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 17/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import HorizonCalendar

protocol CreateRequestModuleInput: AnyObject {
    func setOfferId(_ id: Int)
    func setSelectedDates(_ dates: DayComponentsRange?)
}
