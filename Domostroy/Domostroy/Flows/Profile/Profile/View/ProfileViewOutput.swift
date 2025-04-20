//
//  ProfileViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol ProfileViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func refresh()
    func edit()
    func adminPanel()
    func logout()
}
