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
import Combine
import NodeKit

final class SearchPresenter: SearchModuleOutput {

    // MARK: - SearchModuleOutput

    var onOpenOffer: ((Int) -> Void)?
    var onOpenCity: ((CityEntity?) -> Void)?
    var onOpenSort: ((SortViewModel) -> Void)?
    var onOpenFilters: ((FiltersViewModel) -> Void)?

    // MARK: - Properties

    weak var view: SearchViewInput?
    private weak var paginatableInput: PaginatableInput?

    private let basicStorage: BasicUserDefaultsStorage? = ServiceLocator.shared.resolve()
    private let offerService: OfferService? = ServiceLocator.shared.resolve()

    private var cancellables: Set<AnyCancellable> = .init()

    private var query: String?
    private var isFirstPageLoading = false
    private var pagesCount = 0
    private var currentPage = 0
    private var paginationSnapshot: Date = .now

    private var city: CityEntity?
    private var sort: SortViewModel = .default
    private var filters: FiltersViewModel = .init(
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

    func setCity(_ city: CityEntity?) {
        self.city = city
        view?.setCity(city?.name ?? L10n.Localizable.SelectCity.allCities)
        loadFirstPage()
    }

    func setSort(_ sort: SortViewModel) {
        self.sort = sort
        view?.setSort(sort == .default ? L10n.Localizable.Sort.placeholder : sort.description)
        loadFirstPage()
    }

    func setFilters(_ filters: FiltersViewModel) {
        self.filters = filters
        view?.setHasFilters(filters.isNotEmpty)
        loadFirstPage()
    }
}

// MARK: - SearchViewOutput

extension SearchPresenter: SearchViewOutput {

    func viewLoaded() {
        city = try? .from(dto: basicStorage?.get(for: .defaultCity))
        view?.setCity(city?.name ?? L10n.Localizable.SelectCity.allCities)
        view?.setSort(sort == .default ? L10n.Localizable.Sort.placeholder : sort.description)
        view?.setHasFilters(filters.isNotEmpty)

        view?.setLoading(true)
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
        currentPage = 0
        paginatableInput?.updatePagination(canIterate: false)
        paginatableInput?.updateProgress(isLoading: false)
        paginationSnapshot = .now

        loadFirstPage {
            input.endRefreshing()
        }
    }

}

// MARK: - PaginatableOutput

extension SearchPresenter: PaginatableOutput {

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

private extension SearchPresenter {

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

private extension SearchPresenter {

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
        var sorting: [SortEntity] = []
        if let sortEntity = sort.toSortEntity {
            sorting.append(sortEntity)
        }
        var filtering: [FilterEntity] = []
        if let city, city.id > 0 {
            filtering.append(.init(filterKey: .cityId, operation: .equals, value: AnyEncodable(city.id)))
        } else {
            filtering.append(.init(filterKey: .cityId, operation: .greaterThan, value: AnyEncodable(0)))
        }
        if let category = filters.categoryFilter.selected, category.id > 0 {
            filtering.append(.init(filterKey: .categoryId, operation: .equals, value: AnyEncodable(category.id)))
        }
        if let query, !query.isEmpty {
            let words = query.split(separator: " ").map { String($0) }
            for word in words {
                filtering.append(.init(filterKey: .title, operation: .contains, value: AnyEncodable(word)))
            }
        }
        let searchOffersEntity = SearchOffersEntity(
            pagination: .init(page: currentPage, size: CommonConstants.pageSize),
            sorting: sorting,
            searchCriteriaList: filtering,
            snapshot: paginationSnapshot,
            seed: sort == .default ? "seed" : nil
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
