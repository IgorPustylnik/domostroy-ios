//
//  RequestsViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

struct RequestsTopViewModel {
    let requestType: RequestType
    let requestStatus: RequestStatus

    struct RequestType {
        let all: [String]
        let currentIndex: Int
    }
    struct RequestStatus {
        let all: [String]
        let currentIndex: Int
    }
}

protocol RequestsViewInput: AnyObject {
    func configure(topModel: RequestsTopViewModel)
}
