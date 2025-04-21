//
//  CreateRequestViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 17/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol CreateRequestViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func submit()
}
