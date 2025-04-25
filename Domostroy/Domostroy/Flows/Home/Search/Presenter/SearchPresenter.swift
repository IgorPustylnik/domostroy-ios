//
//  SearchPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 11/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation
import UIKit
import ReactiveDataDisplayManager

enum Sort: CaseIterable {
    case `default`
    case priceAscending
    case priceDescending
    case recent

    var description: String {
        switch self {
        case .default:
            return "Default"
        case .priceAscending:
            return "Price ascending"
        case .priceDescending:
            return "Price descending"
        case .recent:
            return "Most recent"
        }
    }
}

final class SearchPresenter: SearchModuleOutput {

    // MARK: - Constants

    private enum Constants {
        static let pageSize = 10
    }

    // MARK: - SearchModuleOutput

    var onOpenOffer: ((Int) -> Void)?
    var onOpenCity: ((City?) -> Void)?
    var onOpenSort: ((Sort) -> Void)?
    var onOpenFilters: ((Filters) -> Void)?

    // MARK: - Properties

    weak var view: SearchViewInput?
    private weak var paginatableInput: PaginatableInput?

    private var query: String?
    private var isFirstPageLoading = false
    private var pagesCount = 0
    private var currentPage = 0

    private var city: City?
    private var sort: Sort = .default
    private var filters: Filters = .init(
        categoryFilter: .init(all: [])
    )

}

// MARK: - SearchModuleInput

extension SearchPresenter: SearchModuleInput {

    func setQuery(_ query: String?) {
        self.query = query
        view?.setQuery(self.query)
        loadFirstPage()
    }

    func setCity(_ city: City) {
        self.city = city
        view?.setCity(city.name)
        loadFirstPage()
    }

    func setSort(_ sort: Sort) {
        self.sort = sort
        view?.setSort(sort.description)
        loadFirstPage()
    }

    func setFilters(_ filters: Filters) {
        self.filters = filters
        var hasFilters = filters.categoryFilter.selected != nil
        view?.setHasFilters(hasFilters)
        loadFirstPage()
    }
}

// MARK: - SearchViewOutput

extension SearchPresenter: SearchViewOutput {

    func viewLoaded() {
        city = .init(id: 0, name: "Воронеж")
        view?.setCity(city?.name)
        view?.setSort(sort.description)
        view?.setHasFilters(false)

        Task {
            await fetchCategories()
        }

        loadFirstPage()
    }

    func setSearch(active: Bool) {
        view?.setSearchOverlay(active: active)
    }

    func search(query: String?) {
        self.query = query
        view?.setEmptyState(false)
        loadFirstPage()
    }

    func cancelSearchFieldInput() {
        view?.setQuery(self.query)
    }

    func openCity() {
        onOpenCity?(city)
    }

    func openSort() {
        onOpenSort?(sort)
    }

    func openFilters() {
        onOpenFilters?(filters)
    }

    func openOffer(_ id: Int) {
        onOpenOffer?(id)
    }

}

// MARK: - RefreshableOutput

extension SearchPresenter: RefreshableOutput {

    func refreshContent(with input: RefreshableInput) {
        paginatableInput?.updatePagination(canIterate: false)
        paginatableInput?.updateProgress(isLoading: false)

        Task {
            let canIterate = await fillFirst()

            DispatchQueue.main.async { [weak self] in
                input.endRefreshing()
                self?.paginatableInput?.updatePagination(canIterate: canIterate)
                self?.paginatableInput?.updateProgress(isLoading: false)
            }
        }
    }

}

// MARK: - PaginatableOutput

extension SearchPresenter: PaginatableOutput {

    func onPaginationInitialized(with input: PaginatableInput) {
        paginatableInput = input
    }

    func loadNextPage(with input: PaginatableInput) {
        input.updateProgress(isLoading: true)

        Task {
            let canFillNext = canFillNext()

            if canFillNext {
                let canIterate = await fillNext()

                DispatchQueue.main.async {
                    input.updatePagination(canIterate: canIterate)
                    input.updateProgress(isLoading: false)
                }

            } else {
                DispatchQueue.main.async {
                    input.updateProgress(isLoading: false)
                }
            }
        }
    }

}

// MARK: - ViewModels

private extension SearchPresenter {

    func makeOfferViewModel(
        from offer: Offer
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
            imageUrl: offer.images.first,
            loadImage: { [weak self] url, imageView in
                self?.loadImage(url: url, imageView: imageView)
            },
            title: offer.name,
            // TODO: Localize
            price: "\(offer.price.stringDroppingTrailingZero)₽/день",
            location: offer.city.name,
            actions: [],
            toggleActions: toggleActions
        )
        return viewModel
    }
}

// MARK: - Network requests

private extension SearchPresenter {

    func loadImage(url: URL?, imageView: UIImageView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            imageView.kf.setImage(with: url, placeholder: UIImage.Mock.makita)
        }
    }

    func setFavorite(id: Int, value: Bool, completion: ((Bool) -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            completion?(false)
        }
    }

    func loadFirstPage() {
        view?.fillFirstPage(with: [])
        view?.setLoading(true)
        paginatableInput?.updatePagination(canIterate: false)
        paginatableInput?.updateProgress(isLoading: false)

        Task {
            let canIterate = await fillFirst()

            DispatchQueue.main.async { [weak self] in
                self?.view?.setLoading(false)
                self?.paginatableInput?.updatePagination(canIterate: canIterate)
                self?.paginatableInput?.updateProgress(isLoading: false)
            }
        }
    }

    func canFillNext() -> Bool {
        guard !isFirstPageLoading else {
            isFirstPageLoading.toggle()
            return false
        }
        if currentPage < pagesCount {
            return true
        }
        return false
    }

    func fillNext() async -> Bool {
        currentPage += 1

        let page = await _Temporary_Mock_NetworkService().fetchOffers(page: currentPage, pageSize: Constants.pageSize)

        currentPage = page.pagination.currentPage
        pagesCount = page.pagination.totalPages

        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            self.view?.fillNextPage(with: page.offers.map { self.makeOfferViewModel(from: $0) })
        }

        return currentPage < pagesCount
    }

    func fillFirst() async -> Bool {
        isFirstPageLoading = true

        let page = await _Temporary_Mock_NetworkService().fetchOffers(page: 0, pageSize: Constants.pageSize)

        currentPage = page.pagination.currentPage
        pagesCount = page.pagination.totalPages
        isFirstPageLoading = false

        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            self.view?.setEmptyState(page.offers.isEmpty)
            self.view?.fillFirstPage(with: page.offers.map { self.makeOfferViewModel(from: $0) })
        }

        return currentPage < pagesCount
    }

    // MARK: Filters

    func fetchCategories() async {
        let categories = await _Temporary_Mock_NetworkService().fetchCategories()
        self.filters.categoryFilter.all = categories
    }

}
