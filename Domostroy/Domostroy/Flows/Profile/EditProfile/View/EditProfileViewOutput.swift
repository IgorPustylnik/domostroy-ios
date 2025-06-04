//
//  EditProfileViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 14/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol EditProfileViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func firstNameChanged(_ text: String)
    func lastNameChanged(_ text: String)
    func phoneNumberChanged(_ text: String)
    func showChangePassword()
    func save()
}
