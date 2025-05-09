//
//  RequestsPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import ReactiveDataDisplayManager

private enum RequestType: Int, CaseIterable {
    case outgoing
    case incoming

    var description: String {
        switch self {
        case .outgoing:
            return L10n.Localizable.Requests.Outgoing.title
        case .incoming:
            return L10n.Localizable.Requests.Incoming.title
        }
    }
}

final class RequestsPresenter: RequestsModuleOutput {

    // MARK: - RequestsModuleOutput

    // MARK: - Properties

    weak var view: RequestsViewInput?

    private var requestStatusIndex: Int = 0
}

// MARK: - RequestsModuleInput

extension RequestsPresenter: RequestsModuleInput {

}

// MARK: - RequestsViewOutput

extension RequestsPresenter: RequestsViewOutput {

    func viewLoaded() {
        view?.setupSegments(RequestType.allCases.map { $0.description }, selectedIndex: 0)
    }

    func selectRequestStatus(_ index: Int) {
        requestStatusIndex = index
    }

    func openArchive() {

    }

}

// MARK: - RefreshableOutput

extension RequestsPresenter: RefreshableOutput {
    func refreshContent(with input: RefreshableInput) {
        input.endRefreshing()
    }
}

// MARK: - PaginatableOutput

extension RequestsPresenter: PaginatableOutput {
    func onPaginationInitialized(with input: PaginatableInput) {

    }

    func loadNextPage(with input: PaginatableInput) {

    }
}

// MARK: - Private methods

private extension RequestsPresenter {
    func loadFirstPage() {

    }
}
