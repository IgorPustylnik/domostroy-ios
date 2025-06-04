//
//  ProfileBannedViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 04/06/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol ProfileBannedViewInput: AnyObject {
    /// Method for setup initial state of view
    func setupInitialState()
    func setLoading(_ isLoading: Bool)
    func endRefreshing()
}
