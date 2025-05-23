//
//  OfferAdminFilterModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 23/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol OfferAdminFilterModuleOutput: AnyObject {
    var onApply: ((OfferAdminFilterViewModel) -> Void)? { get set }
    var onDismiss: EmptyClosure? { get set }
}
