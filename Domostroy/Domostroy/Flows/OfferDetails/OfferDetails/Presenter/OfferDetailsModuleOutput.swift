//
//  OfferDetailsModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 10/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation

protocol OfferDetailsModuleOutput: AnyObject {
    var onOpenUser: ((Int) -> Void)? { get set }
    var onOpenFullScreenImages: (([URL], Int) -> Void)? { get set }
    var onRent: EmptyClosure? { get set }
    var onDeinit: EmptyClosure? { get set }
    var onDismiss: EmptyClosure? { get set }
}
