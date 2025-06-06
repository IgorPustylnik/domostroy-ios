//
//  CodeConfirmationViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 05/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation

protocol CodeConfirmationViewInput: AnyObject {
    /// Method for setup initial state of view
    func setupInitialState(length: Int, email: String)
}
