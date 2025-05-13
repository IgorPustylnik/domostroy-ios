//
//  OutgoingRequestsViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 11/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

// swiftlint:disable disclosure_of_view_details
protocol OutgoingRequestsViewInput: AnyObject, EmptyStateable, Loadable {
    func fillFirstPage(with viewModels: [OutgoingRequestCollectionViewCell.ViewModel])
    func fillNextPage(with viewModels: [OutgoingRequestCollectionViewCell.ViewModel])
}
