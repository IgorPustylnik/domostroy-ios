//
//  MainTabBarViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

protocol MainTabBarViewInput: AnyObject {
    /// Method for setup initial state of view
    func configure(controllers: [UIViewController])
    func setCenterControl(enabled: Bool)
}
