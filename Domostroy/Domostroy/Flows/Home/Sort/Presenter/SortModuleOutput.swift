//
//  SortModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 22/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol SortModuleOutput: AnyObject {
    var onApply: ((Sort) -> Void)? { get set }
    var onDismiss: EmptyClosure? { get set }
}
