//
//  MyOffersModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol MyOffersModuleOutput: AnyObject {
    var onSetCenterControlEnabled: ((Bool) -> Void)? { get set }
}
