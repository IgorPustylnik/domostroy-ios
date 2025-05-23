//
//  UsersAdminViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 21/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol UsersAdminViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func openUser(id: Int)
}
