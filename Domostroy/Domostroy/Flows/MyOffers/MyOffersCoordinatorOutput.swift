//
//  MyOffersCoordinatorOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

protocol MyOffersCoordinatorOutput: AnyObject {
    var onSetTabBarCenterControlEnabled: ((Bool) -> Void)? { get set }
    var onChangeAuthState: EmptyClosure? { get set }
}
