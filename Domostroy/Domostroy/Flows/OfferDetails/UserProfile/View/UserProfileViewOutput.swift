//
//  UserProfileViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 24/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol UserProfileViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func openOffer(_ id: Int)
}
