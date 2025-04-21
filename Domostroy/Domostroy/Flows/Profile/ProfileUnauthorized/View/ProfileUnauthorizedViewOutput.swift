//
//  ProfileUnauthorizedViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 21/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol ProfileUnauthorizedViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func authorize()
}
