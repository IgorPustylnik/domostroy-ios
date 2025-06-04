//
//  SortViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 22/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol SortViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func apply(sort: SortViewModel)
    func dismiss()
}
