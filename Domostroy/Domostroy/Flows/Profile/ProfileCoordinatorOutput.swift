//
//  ProfileCoordinatorOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

protocol ProfileCoordinatorOutput: AnyObject {
    var onChangeAuthState: EmptyClosure? { get set }
}
