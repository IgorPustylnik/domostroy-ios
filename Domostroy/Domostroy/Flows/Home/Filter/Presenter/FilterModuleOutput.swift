//
//  FilterModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 23/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol FilterModuleOutput: AnyObject {
    var onApply: ((Filters) -> Void)? { get set }
    var onDismiss: EmptyClosure? { get set }
}
