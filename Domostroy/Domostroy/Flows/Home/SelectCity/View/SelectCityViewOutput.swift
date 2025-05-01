//
//  SelectCityViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 01/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol SelectCityViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func search(query: String?)
    func apply()
    func dismiss()
}
