//
//  IncomingRequestDetailsModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 13/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol IncomingRequestDetailsModuleOutput: AnyObject {
    var onOpenOffer: ((Int) -> Void)? { get set }
    var onOpenUser: ((Int) -> Void)? { get set }
    var onDismiss: EmptyClosure? { get set }
}
