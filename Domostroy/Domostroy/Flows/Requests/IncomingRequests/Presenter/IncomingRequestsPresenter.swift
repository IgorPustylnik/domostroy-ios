//
//  IncomingRequestsPresenter.swift
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

final class IncomingRequestsPresenter: IncomingRequestsModuleOutput {

    // MARK: - RequestsModuleOutput

    // MARK: - Properties

    weak var view: IncomingRequestsViewInput?
    private weak var paginatableInput: PaginatableInput?

    private let offerService: OfferService? = ServiceLocator.shared.resolve()
    private var cancellables: Set<AnyCancellable> = .init()

    private var isFirstPageLoading = false
    private var pagesCount = 0
    private var currentPage = 0
    private var paginationSnapshot: Date = .now
}

// MARK: - IncomingRequestsModuleInput

extension IncomingRequestsPresenter: IncomingRequestsModuleInput {

}

// MARK: - IncomingRequestsViewOutput

extension IncomingRequestsPresenter: IncomingRequestsViewOutput {

    func viewLoaded() {
        view?.setLoading(true)
        loadFirstPage()
    }

}

// MARK: - RefreshableOutput

extension IncomingRequestsPresenter: RefreshableOutput {
    func refreshContent(with input: RefreshableInput) {
        loadFirstPage {
            input.endRefreshing()
        }
    }
}

// MARK: - PaginatableOutput

extension IncomingRequestsPresenter: PaginatableOutput {
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
                self.view?.setEmptyState(page.data.isEmpty)
                self.view?.fillNextPage(with: page.data.map { self.makeIncomingRequestViewModel(from: $0) })
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

private extension IncomingRequestsPresenter {

    func makeIncomingRequestViewModel(
        from request: RentalRequestEntity
    ) -> IncomingRequestCollectionViewCell.ViewModel {
        var actions: [IncomingRequestCollectionViewCell.ViewModel.Action] = []
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
                type: .filledPrimary,
                image: nil,
                title: L10n.Localizable.Requests.Action.accept
            ) { [weak self] in
                self?.acceptRequest(id: request.id)
            })
            actions.append(.init(
                type: .destructive,
                image: nil,
                title: L10n.Localizable.Requests.Action.decline
            ) { [weak self] in
                self?.declineRequest(id: request.id)
            })
        case .declined:
            break
        }
        let viewModel = IncomingRequestCollectionViewCell.ViewModel(
            id: request.id,
            imageUrl: request.offer.photoUrl,
            loadImage: { [weak self] url, imageView in
                self?.loadImage(url: url, imageView: imageView)
            },
            title: request.offer.title,
            price: LocalizationHelper.pricePerDay(for: request.offer.price),
            dates: "\(L10n.Localizable.Requests.Info.dates): \(request.dates.formattedDateRanges())",
            leaser: "\(L10n.Localizable.Requests.Info.leaser): \(request.user.name)",
            location: request.offer.city,
            status: request.status,
            actions: actions
        )
        return viewModel
    }
}

// MARK: - Private methods

private extension IncomingRequestsPresenter {

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

    func acceptRequest(id: Int) {
        print("accept request id: \(id)")
    }

    func declineRequest(id: Int) {
        print("decline request id: \(id)")
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
                    self.view?.fillFirstPage(with: page.data.compactMap { self.makeIncomingRequestViewModel(from: $0) })
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
