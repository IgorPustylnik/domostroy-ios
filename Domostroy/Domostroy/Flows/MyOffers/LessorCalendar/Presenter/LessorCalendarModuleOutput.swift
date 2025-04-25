//
//  LessorCalendarModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 25/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation

protocol LessorCalendarModuleOutput: AnyObject {
    var onDismiss: EmptyClosure? { get set }
    var onApply: ((Set<Date>) -> Void)? { get set }
}
