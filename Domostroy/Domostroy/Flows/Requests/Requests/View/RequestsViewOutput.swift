//
//  RequestsViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol RequestsViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func selectRequestType(_ index: Int)
    func selectRequestStatus(_ index: Int)
}
