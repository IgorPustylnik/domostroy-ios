//
//  OutgoingRequestDetailsViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 13/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

protocol OutgoingRequestDetailsViewInput: AnyObject, Loadable {
    /// Method for setup initial state of view
    func setupInitialState()
    func configure(with viewModel: OutgoingRequestDetailsView.ViewModel, moreActions: [UIAction])
}
