//
//  AuthCoordinatorOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 04/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

protocol AuthCoordinatorOutput: AnyObject {
    var onComplete: EmptyClosure? { get set }
    var onSuccessfulAuth: EmptyClosure? { get set }
}
