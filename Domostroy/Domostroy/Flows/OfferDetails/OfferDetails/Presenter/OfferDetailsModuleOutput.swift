//
//  OfferDetailsModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 10/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol OfferDetailsModuleOutput: AnyObject {
    var onOpenUser: ((Int) -> Void)? { get set }
    var onRent: EmptyClosure? { get set }
}
