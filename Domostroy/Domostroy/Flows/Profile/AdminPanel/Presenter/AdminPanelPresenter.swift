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

    // MARK: - Properties

    weak var view: AdminPanelViewInput?

    private var segment: AdminPanelPresenterModel.Segment = .users

}

// MARK: - AdminPanelModuleInput

extension AdminPanelPresenter: AdminPanelModuleInput {

    func present(_ presentable: Presentable, scrollView: UIScrollView?) {
        view?.setRoot(presentable, scrollView: scrollView)

        if let scrollView {
            let originalOffset = scrollView.contentOffset
            scrollView.setContentOffset(CGPoint(x: originalOffset.x, y: originalOffset.y + 0.01), animated: false)
            scrollView.setContentOffset(originalOffset, animated: false)
        }
    }

}

// MARK: - AdminPanelViewOutput

extension AdminPanelPresenter: AdminPanelViewOutput {

    func viewLoaded() {
        view?.setupSegments(AdminPanelPresenterModel.Segment.allCases.map { $0.description }, selectedIndex: 0)
        onPresentSegment?(segment)
    }

    func selectSegment(_ index: Int) {
        segment = .init(rawValue: index) ?? .users
        onPresentSegment?(segment)
    }

}
