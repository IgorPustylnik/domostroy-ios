//
//  RequestsModuleInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

protocol RequestsModuleInput: AnyObject {
    func present(_ presentable: Presentable, scrollView: UIScrollView?)
}
