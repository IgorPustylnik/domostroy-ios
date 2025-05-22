//
//  AdminPanelViewInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 21/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

protocol AdminPanelViewInput: AnyObject {
    func setupSegments(_ values: [String], selectedIndex: Int)
    func setRoot(_ presentable: Presentable, as segment: AdminPanelPresenterModel.Segment, scrollView: UIScrollView?)
    func setSearchQuery(_ query: String?)
    func setSearchOverlay(active: Bool, from segment: AdminPanelPresenterModel.Segment)
    func setOffersCity(_ city: String)
    func setOffersSort(_ sort: String)
    func setOffersHasFilters(_ hasFilters: Bool)
}
