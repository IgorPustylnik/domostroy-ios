//
//  UserProfileModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 24/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol UserProfileModuleOutput: AnyObject {
    var onOpenOffer: ((Int) -> Void)? { get set }
    var onDismiss: EmptyClosure? { get set }
}
