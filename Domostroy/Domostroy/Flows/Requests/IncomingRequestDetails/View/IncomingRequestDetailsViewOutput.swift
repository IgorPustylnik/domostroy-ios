//
//  IncomingRequestDetailsViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 13/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol IncomingRequestDetailsViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func openOffer()
    func openUser()
    func call()
    func accept()
    func decline()
}
