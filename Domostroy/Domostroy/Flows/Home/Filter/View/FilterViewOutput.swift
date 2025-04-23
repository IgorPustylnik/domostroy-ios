//
//  FilterViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 23/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol FilterViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func selectCategory(index: Int)

    func apply()
    func dismiss()
}
