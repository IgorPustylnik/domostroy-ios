//
//  ChangePasswordViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 14/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol ChangePasswordViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func oldPasswordChanged(_ text: String)
    func newPasswordChanged(_ text: String)
    func save()
}
