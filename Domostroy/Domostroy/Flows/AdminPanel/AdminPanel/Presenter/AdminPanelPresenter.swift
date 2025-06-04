//
//  AdminPanelPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 21/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation
import UIKit

final class AdminPanelPresenter: AdminPanelModuleOutput {

    // MARK: - AdminPanelModuleOutput

    var onPresentSegment: ((AdminPanelPresenterModel.Segment) -> Void)?
    var onSearch: ((String?, AdminPanelPresenterModel.Segment) -> Void)?

    // MARK: - Properties

    weak var view: AdminPanelViewInput?

    weak var offersInput: OffersAdminModuleInput?

    private var segment: AdminPanelPresenterModel.Segment = .users
    private var query: String?

}

// MARK: - AdminPanelModuleInput

extension AdminPanelPresenter: AdminPanelModuleInput {

    func present(_ presentable: Presentable, as segment: AdminPanelPresenterModel.Segment, scrollView: UIScrollView?) {
        view?.setRoot(presentable, as: segment, scrollView: scrollView)

        if let scrollView {
            let originalOffset = scrollView.contentOffset
            scrollView.setContentOffset(CGPoint(x: originalOffset.x, y: originalOffset.y + 0.01), animated: false)
            scrollView.setContentOffset(originalOffset, animated: false)
        }
    }

    func setSearchQuery(_ query: String?) {
        view?.setSearchQuery(query)
    }

    func setOffersCity(_ city: String) {
        view?.setOffersCity(city)
    }

    func setOffersSort(_ sort: String) {
        view?.setOffersSort(sort)
    }

    func setOffersHasFilters(_ hasFilters: Bool) {
        view?.setOffersHasFilters(hasFilters)
    }

    func setOffersAdminModuleInput(_ input: OffersAdminModuleInput?) {
        self.offersInput = input
    }

}

// MARK: - AdminPanelViewOutput

extension AdminPanelPresenter: AdminPanelViewOutput {
    func viewLoaded() {
        view?.setupSegments(AdminPanelPresenterModel.Segment.allCases.map { $0.description }, selectedIndex: 0)
        onPresentSegment?(segment)
    }

    func setSearch(active: Bool) {
        view?.setSearchOverlay(active: active, from: segment)
    }

    func search(query: String?) {
        self.query = query
        onSearch?(query, segment)
    }

    func cancel() {
        view?.setSearchQuery(query)
    }

    func selectSegment(_ index: Int) {
        segment = .init(rawValue: index) ?? .users
        onPresentSegment?(segment)
    }

    func showOfferSearchCity() {
        offersInput?.openCities()
    }

    func showOfferSearchSort() {
        offersInput?.openSort()
    }

    func showOfferSearchFilters() {
        offersInput?.openFilters()
    }

}
