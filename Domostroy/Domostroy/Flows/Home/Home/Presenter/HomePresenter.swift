//
//  HomePresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation
import UIKit
import ReactiveDataDisplayManager
import Kingfisher
import Combine
import NodeKit

final class HomePresenter: HomeModuleOutput {

    // MARK: - Constants

    private enum Constants {
        static let pageSize = 10
    }

    // MARK: - HomeModuleOutput

    var onOpenOffer: ((Int) -> Void)?
    var onSearch: ((String?) -> Void)?

    // MARK: - Properties

    weak var view: HomeViewInput?
    private weak var paginatableInput: PaginatableInput?

    private let offerService: OfferService? = ServiceLocator.shared.resolve()
    private var cancellables: Set<AnyCancellable> = .init()

    private var isFirstPageLoading = false
    private var pagesCount = 0
    private var currentPage = 0
    private var paginationSnapshot: Date = .now
    private var seed: String {
        "\(Int(Date().timeIntervalSince1970) / (60 * 5))"
    }

}

// MARK: - HomeModuleInput

extension HomePresenter: HomeModuleInput {

}

// MARK: - HomeViewOutput

extension HomePresenter: HomeViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
        loadFirstPage()
    }

    func setSearch(active: Bool) {
        view?.setSearchOverlay(active: active)
    }

    func search(query: String?) {
        onSearch?(query)
    }

    func openOffer(_ id: Int) {
        onOpenOffer?(id)
    }

}

// MARK: - RefreshableOutput

extension HomePresenter: RefreshableOutput {

    func refreshContent(with input: RefreshableInput) {
        loadFirstPage {
            input.endRefreshing()
        }
    }

}

// MARK: - PaginatableOutput

extension HomePresenter: PaginatableOutput {

    func onPaginationInitialized(with input: PaginatableInput) {
        paginatableInput = input
    }

    func loadNextPage(with input: PaginatableInput) {
        guard canLoadNext() else {
            return
        }
        input.updateProgress(isLoading: true)
        currentPage += 1

        fetchOffers { [weak self] in
            self?.updatePagination()
            input.updateProgress(isLoading: false)
        } handleResult: { [weak self] result in
            switch result {
            case .success(let page):
                guard let self else {
                    return
                }
                self.pagesCount = page.pagination.totalPages
                self.view?.setEmptyState(page.data.isEmpty)
                self.view?.fillNextPage(with: page.data.map { self.makeOfferViewModel(from: $0) })
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

private extension HomePresenter {

    func makeOfferViewModel(
        from offer: BriefOfferEntity
    ) -> OfferCollectionViewCell.ViewModel {
        let toggleActions: [OfferCollectionViewCell.ViewModel.ToggleButtonModel] = [
            .init(
                initialState: offer.isFavorite,
                onImage: .Buttons.favoriteFilled.withTintColor(.Domostroy.primary, renderingMode: .alwaysOriginal),
                offImage: .Buttons.favorite.withTintColor(.Domostroy.primary, renderingMode: .alwaysOriginal),
                toggleAction: { [weak self] newValue, handler in
                    self?.setFavorite(id: offer.id, value: newValue) { success in
                        handler?(success)
                    }
                }
            )
        ]
        let viewModel = OfferCollectionViewCell.ViewModel(
            id: offer.id,
            imageUrl: offer.photoUrl,
            loadImage: { [weak self] url, imageView in
                self?.loadImage(url: url, imageView: imageView)
            },
            title: offer.title,
            price: LocalizationHelper.pricePerDay(for: offer.price),
            location: offer.city,
            actions: [],
            toggleActions: toggleActions
        )
        return viewModel
    }
}

// MARK: - Network requests

private extension HomePresenter {

    func loadImage(url: URL?, imageView: UIImageView) {
        DispatchQueue.main.async {
            imageView.kf.setImage(with: url)
        }
    }

    func setFavorite(id: Int, value: Bool, completion: ((Bool) -> Void)?) {
        offerService?.toggleFavorite(id: id)
            .sink(
                receiveValue: { result in
                    switch result {
                    case .success:
                        completion?(true)
                    case .failure(let error):
                        completion?(false)
                        DropsPresenter.shared.showError(error: error)
                    }
                }
            )
            .store(in: &cancellables)
    }

    func loadFirstPage(completion: (() -> Void)? = nil) {
        currentPage = 0
        paginationSnapshot = .now
        view?.fillFirstPage(with: [])
        view?.setLoading(true)
        paginatableInput?.updatePagination(canIterate: false)
        paginatableInput?.updateProgress(isLoading: false)

        fetchOffers { [weak self] in
            self?.view?.setLoading(false)
            self?.updatePagination()
            self?.paginatableInput?.updateProgress(isLoading: false)
            completion?()
        } handleResult: { [weak self] result in
            switch result {
            case .success(let page):
                guard let self else {
                    return
                }
                self.pagesCount = page.pagination.totalPages
                self.view?.setEmptyState(page.data.isEmpty)
                self.view?.fillFirstPage(with: page.data.compactMap { self.makeOfferViewModel(from: $0) })
            case .failure(let error):
                DropsPresenter.shared.showError(error: error)
            }
        }
    }

    func fetchOffers(
        completion: EmptyClosure?,
        handleResult: ((NodeResult<PageEntity<BriefOfferEntity>>) -> Void)?
    ) {
        var filtering: [FilterEntity] = []
        filtering.append(.init(filterKey: .cityId, operation: .greaterThan, value: AnyEncodable(0)))
        let searchOffersEntity = SearchOffersEntity(
            pagination: .init(page: currentPage, size: CommonConstants.pageSize),
            sorting: [],
            searchCriteriaList: filtering,
            snapshot: paginationSnapshot,
            seed: seed
        )
        offerService?.getOffers(searchOffersEntity: searchOffersEntity)
            .sink(
                receiveCompletion: { _ in
                    completion?()
                },
                receiveValue: { result in
                    handleResult?(result)
                }
            )
            .store(in: &cancellables)
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
