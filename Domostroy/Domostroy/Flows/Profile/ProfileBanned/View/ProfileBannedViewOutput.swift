//
//  ProfileBannedViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 04/06/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol ProfileBannedViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func refresh()
    func logout()
}
