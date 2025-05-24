//
//  AdminPanelModuleInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 21/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

protocol AdminPanelModuleInput: AnyObject {
    func present(_ presentable: Presentable, as segment: AdminPanelPresenterModel.Segment, scrollView: UIScrollView?)
    func setSearchQuery(_ query: String?)
    func setOffersCity(_ city: String)
    func setOffersSort(_ sort: String)
    func setOffersHasFilters(_ hasFilters: Bool)
    func setOffersAdminModuleInput(_ input: OffersAdminModuleInput?)
}
