//
//  CreateRequestModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 17/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol CreateRequestModuleOutput: AnyObject {
    var onShowCalendar: ((RequestCalendarConfig?) -> Void)? { get set }
}
