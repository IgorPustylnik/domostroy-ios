//
//  MyOfferDetailsModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 15/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation

protocol MyOfferDetailsModuleOutput: AnyObject {
    var onOpenFullScreenImages: (([URL], Int) -> Void)? { get set }
    var onEdit: ((Int) -> Void)? { get set }
    var onDeleted: EmptyClosure? { get set }
    var onCalendar: ((Int) -> Void)? { get set }
    var onDismiss: EmptyClosure? { get set }
}
