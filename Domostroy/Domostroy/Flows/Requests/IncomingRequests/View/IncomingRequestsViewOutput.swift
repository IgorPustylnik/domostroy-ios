//
//  IncomingRequestsViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 11/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol IncomingRequestsViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func openRequestDetails(id: Int)
}
