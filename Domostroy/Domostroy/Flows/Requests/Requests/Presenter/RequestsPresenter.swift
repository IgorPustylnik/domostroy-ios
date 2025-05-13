//
//  RequestsPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import ReactiveDataDisplayManager
import Combine
import NodeKit

final class RequestsPresenter: RequestsModuleOutput {

    // MARK: - RequestsModuleOutput

    var onPresentSegment: ((RequestsPresenterModel.Segment) -> Void)?

    // MARK: - Properties

    weak var view: RequestsViewInput?

    private var segment: RequestsPresenterModel.Segment = .outgoing

}

// MARK: - RequestsModuleInput

extension RequestsPresenter: RequestsModuleInput {

    func present(_ presentable: Presentable, scrollView: UIScrollView?) {
        view?.setRoot(presentable, scrollView: scrollView)

        if let scrollView {
            let originalOffset = scrollView.contentOffset
            scrollView.setContentOffset(CGPoint(x: originalOffset.x, y: originalOffset.y + 0.01), animated: false)
            scrollView.setContentOffset(originalOffset, animated: false)
        }
    }

}

// MARK: - RequestsViewOutput

extension RequestsPresenter: RequestsViewOutput {

    func viewLoaded() {
        view?.setupSegments(RequestsPresenterModel.Segment.allCases.map { $0.description }, selectedIndex: 0)
        onPresentSegment?(.outgoing)
    }

    func selectRequestStatus(_ index: Int) {
        segment = .init(rawValue: index) ?? .outgoing
        onPresentSegment?(segment)
    }

}
