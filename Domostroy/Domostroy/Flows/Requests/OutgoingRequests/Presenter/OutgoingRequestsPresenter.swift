//
//  OutgoingRequestsPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 11/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import ReactiveDataDisplayManager
import Combine
import NodeKit

final class OutgoingRequestsPresenter: OutgoingRequestsModuleOutput {

    // MARK: - RequestsModuleOutput

    // MARK: - Properties

    weak var view: OutgoingRequestsViewInput?
    private weak var paginatableInput: PaginatableInput?

    private let offerService: OfferService? = ServiceLocator.shared.resolve()
    private var cancellables: Set<AnyCancellable> = .init()

    private var isFirstPageLoading = false
    private var pagesCount = 0
    private var currentPage = 0
    private var paginationSnapshot: Date = .now
}

// MARK: - OutgoingRequestsModuleInput

extension OutgoingRequestsPresenter: OutgoingRequestsModuleInput {

}

// MARK: - OutgoingRequestsViewOutput

extension OutgoingRequestsPresenter: OutgoingRequestsViewOutput {

    func viewLoaded() {
        view?.setLoading(true)
        loadFirstPage()
    }

}

// MARK: - RefreshableOutput

extension OutgoingRequestsPresenter: RefreshableOutput {
    func refreshContent(with input: RefreshableInput) {
        loadFirstPage {
            input.endRefreshing()
        }
    }
}

// MARK: - PaginatableOutput

extension OutgoingRequestsPresenter: PaginatableOutput {
    func onPaginationInitialized(with input: PaginatableInput) {
        paginatableInput = input
    }

    func loadNextPage(with input: PaginatableInput) {
        guard canLoadNext() else {
            return
        }
        input.updateProgress(isLoading: true)
        currentPage += 1

        fetchRequests {
            input.updateProgress(isLoading: false)
        } handleResult: { [weak self] result in
            switch result {
            case .success(let page):
                guard let self else {
                    return
                }
                self.pagesCount = page.pagination.totalPages
                self.updatePagination()
                self.view?.fillNextPage(with: page.data.map { self.makeOutgoingRequestViewModel(from: $0) })
            case .failure(let error):
                DropsPresenter.shared.showError(error: error)
            }
        }
    }

    func updatePagination() {
        paginatableInput?.updatePagination(canIterate: canLoadNext())
    }
}

// MARK: - ViewModels

private extension OutgoingRequestsPresenter {

    func makeOutgoingRequestViewModel(
        from request: RentalRequestEntity
    ) -> OutgoingRequestCollectionViewCell.ViewModel {
        var actions: [OutgoingRequestCollectionViewCell.ViewModel.Action] = []
        switch request.status {
        case .accepted:
            actions.append(.init(
                type: .filledPrimary,
                image: nil,
                title: L10n.Localizable.Requests.Action.call
            ) { [weak self] in
                self?.callPhoneNumber(request.user.phoneNumber)
            })
        case .pending:
            actions.append(.init(
                type: .destructive,
                image: nil,
                title: L10n.Localizable.Requests.Action.cancelRequest
            ) { [weak self] in
                self?.cancelRequest(id: request.id)
            })
        case .declined:
            break
        }
        let viewModel = OutgoingRequestCollectionViewCell.ViewModel(
            id: request.id,
            imageUrl: request.offer.photoUrl,
            loadImage: { [weak self] url, imageView in
                self?.loadImage(url: url, imageView: imageView)
            },
            title: request.offer.title,
            price: LocalizationHelper.pricePerDay(for: request.offer.price),
            dates: "\(L10n.Localizable.Requests.Info.dates): \(request.dates.formattedDateRanges())",
            leaser: "\(L10n.Localizable.Requests.Info.lessor): \(request.user.name)",
            location: request.offer.city,
            status: request.status,
            actions: actions
        )
        return viewModel
    }
}

// MARK: - Private methods

private extension OutgoingRequestsPresenter {

    func loadImage(url: URL?, imageView: UIImageView) {
        DispatchQueue.main.async {
            imageView.kf.setImage(with: url)
        }
    }

    func callPhoneNumber(_ number: String) {
        if let url = URL(string: "tel://\(number)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    func cancelRequest(id: Int) {
        print("cancel request id: \(id)")
    }

    func loadFirstPage(completion: (() -> Void)? = nil) {
        currentPage = 0
        paginationSnapshot = .now
        paginatableInput?.updatePagination(canIterate: false)
        paginatableInput?.updateProgress(isLoading: false)
        isFirstPageLoading = true

        fetchRequests { [weak self] in
            self?.view?.setLoading(false)
            self?.paginatableInput?.updateProgress(isLoading: false)
            self?.isFirstPageLoading = false
            completion?()
        } handleResult: { [weak self] result in
            switch result {
            case .success(let page):
                guard let self else {
                    return
                }
                DispatchQueue.main.async {
                    self.pagesCount = page.pagination.totalPages
                    self.updatePagination()
                    self.view?.setEmptyState(page.data.isEmpty)
                    self.view?.fillFirstPage(with: page.data.compactMap { self.makeOutgoingRequestViewModel(from: $0) })
                }
            case .failure(let error):
                DropsPresenter.shared.showError(error: error)
            }
        }
    }

    func fetchRequests(
        completion: EmptyClosure?,
        handleResult: ((NodeResult<PageEntity<RentalRequestEntity>>) -> Void)?
    ) {
        Task {
            let result = await _Temporary_Mock_NetworkService().fetchRequests()
            DispatchQueue.main.async {
                completion?()
                handleResult?(result)
            }
        }
    }

    func canLoadNext() -> Bool {
        guard !isFirstPageLoading else {
            isFirstPageLoading.toggle()
            return false
        }
        if currentPage < pagesCount - 1 {
            return true
        }
        return false
    }
}
