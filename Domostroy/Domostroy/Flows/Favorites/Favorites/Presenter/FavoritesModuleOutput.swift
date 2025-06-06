//
//  FavoritesModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol FavoritesModuleOutput: AnyObject {
    var onOpenSort: ((SortViewModel) -> Void)? { get set }
    var onOpenOffer: ((Int) -> Void)? { get set }
}
