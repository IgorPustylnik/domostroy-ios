//
//  RequestsViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol RequestsViewInput: AnyObject {
    func setupSegments(_ values: [String], selectedIndex: Int)
}
