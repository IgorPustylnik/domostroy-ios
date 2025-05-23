//
//  OffersAdminViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 23/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

// swiftlint:disable disclosure_of_view_details
protocol OffersAdminViewInput: AnyObject, Loadable, EmptyStateable {
    func fillFirstPage(with viewModels: [OfferAdminCollectionViewCell.ViewModel])
    func fillNextPage(with viewModels: [OfferAdminCollectionViewCell.ViewModel])
}
