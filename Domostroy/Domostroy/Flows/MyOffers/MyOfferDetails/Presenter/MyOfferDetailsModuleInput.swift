//
//  MyOfferDetailsModuleInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 15/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol MyOfferDetailsModuleInput: AnyObject, Reloadable {
    func set(offerId: Int)
    func setImage(index: Int)
}
