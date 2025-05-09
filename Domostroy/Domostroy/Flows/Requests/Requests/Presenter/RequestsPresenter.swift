//
//  RequestsPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import ReactiveDataDisplayManager

// Temporary model
private enum Request {
    enum RequestType: Int, CaseIterable {
        case incoming
        case outcoming

        var description: String {
            switch self {
            case .incoming:
                return L10n.Localizable.Requests.Incoming.title
            case .outcoming:
                return L10n.Localizable.Requests.Outcoming.title
            }
        }
    }
    enum RequestStatus: Int, CaseIterable {
        case accepted
        case pending
        case declined

        var description: String {
            switch self {
            case .accepted:
                return L10n.Localizable.Requests.Accepted.title
            case .pending:
                return L10n.Localizable.Requests.Pending.title
            case .declined:
                return L10n.Localizable.Requests.Declined.title
            }
        }
    }
}

final class RequestsPresenter: RequestsModuleOutput {

    // MARK: - RequestsModuleOutput

    // MARK: - Properties

    weak var view: RequestsViewInput?

    private var requestTypeIndex: Int = 0
    private var requestStatusIndex: Int = 0
}

// MARK: - RequestsModuleInput

extension RequestsPresenter: RequestsModuleInput {

}

// MARK: - RequestsViewOutput

extension RequestsPresenter: RequestsViewOutput {

    func viewLoaded() {
        view?.configure(
            topModel: .init(
                requestType: .init(
                    all: Request.RequestType.allCases.map { $0.description },
                    currentIndex: requestTypeIndex
                ),
                requestStatus: .init(
                    all: Request.RequestStatus.allCases.map { $0.description },
                    currentIndex: requestStatusIndex
                )
            )
        )
    }

    func selectRequestType(_ index: Int) {
        requestTypeIndex = index
    }

    func selectRequestStatus(_ index: Int) {
        requestStatusIndex = index
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
