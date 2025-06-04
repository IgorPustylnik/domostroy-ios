//
//  RequestsViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

protocol RequestsViewInput: AnyObject {
    func setupSegments(_ values: [String], selectedIndex: Int)
    func setRoot(_ presentable: Presentable, scrollView: UIScrollView?)
}
