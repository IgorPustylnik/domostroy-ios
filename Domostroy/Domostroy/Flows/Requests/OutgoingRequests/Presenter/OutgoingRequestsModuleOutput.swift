//
//  OutgoingRequestsModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 11/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol OutgoingRequestsModuleOutput: AnyObject {
    var onShowRequestDetails: ((Int) -> Void)? { get set }
}
