//
//  UsersAdminViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 21/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

// swiftlint:disable disclosure_of_view_details
protocol UsersAdminViewInput: AnyObject, EmptyStateable, Loadable {
    func fillFirstPage(with viewModels: [UserAdminCollectionViewCell.ViewModel])
    func fillNextPage(with viewModels: [UserAdminCollectionViewCell.ViewModel])
}
