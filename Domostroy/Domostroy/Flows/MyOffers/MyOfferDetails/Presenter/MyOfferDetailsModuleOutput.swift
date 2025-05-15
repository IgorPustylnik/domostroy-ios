//
//  MyOfferDetailsModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 15/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol MyOfferDetailsModuleOutput: AnyObject {
    var onEdit: ((Int) -> Void)? { get set }
    var onDeleted: EmptyClosure? { get set }
    var onCalendar: ((Int) -> Void)? { get set }
    var onDismiss: EmptyClosure? { get set }
}
