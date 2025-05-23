//
//  OffersAdminPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 23/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation
import UIKit
import ReactiveDataDisplayManager
import Combine
import NodeKit

final class OffersAdminPresenter: OffersAdminModuleOutput {

    // MARK: - OffersAdminModuleOutput

    var onOpenOffer: ((Int) -> Void)?
    var onOpenCity: ((CityEntity?) -> Void)?
    var onOpenSort: ((SortViewModel) -> Void)?
    var onOpenFilters: ((OfferAdminFilterViewModel) -> Void)?

    func getSearchQuery() -> String? {
        query
    }

    // MARK: - Properties

    weak var adminPanelInput: AdminPanelModuleInput?

    weak var view: OffersAdminViewInput?
    private weak var paginatableInput: PaginatableInput?

    private let basicStorage: BasicStorage? = ServiceLocator.shared.resolve()
    private let secureStorage: SecureStorage? = ServiceLocator.shared.resolve()
    private let adminService: AdminService? = ServiceLocator.shared.resolve()
    private let offerService: OfferService? = ServiceLocator.shared.resolve()

    private var cancellables: Set<AnyCancellable> = .init()

    private var query: String?
    private var isFirstPageLoading = false
    private var pagesCount = 0
    private var currentPage = 0
    private var paginationSnapshot: Date = .now

    private var city: CityEntity?
    private var sort: SortViewModel = .default
    private var filters: OfferAdminFilterViewModel = .init(
        categoryFilter: .init(all: []),
        priceFilter: (nil, nil),
        statusFilter: .all
    )

    private var hasLoadedInitially = false

}

// MARK: - OffersAdminModuleInput

extension OffersAdminPresenter: OffersAdminModuleInput {

    func setAdminPanelModuleInput(_ input: AdminPanelModuleInput?) {
        self.adminPanelInput = input
    }

    func search(_ query: String?) {
        self.query = query
        if hasLoadedInitially {
            view?.setLoading(true)
            view?.fillFirstPage(with: [])
            loadFirstPage()
        }
    }

    func setCity(_ city: CityEntity?) {
        self.city = city
        adminPanelInput?.setOffersCity(city?.name ?? L10n.Localizable.SelectCity.allCities)
        if let city {
            try? basicStorage?.set(city.toDTO(), for: .defaultCity)
        }
        if hasLoadedInitially {
            view?.setLoading(true)
            view?.fillFirstPage(with: [])
            loadFirstPage()
        }
    }

    func setSort(_ sort: SortViewModel) {
        self.sort = sort
        adminPanelInput?.setOffersSort(sort == .default ? L10n.Localizable.Sort.placeholder : sort.description)
        if hasLoadedInitially {
            view?.setLoading(true)
            view?.fillFirstPage(with: [])
            loadFirstPage()
        }
    }

    func setFilters(_ filters: OfferAdminFilterViewModel) {
        self.filters = filters
        adminPanelInput?.setOffersHasFilters(filters.isNotEmpty)
        if hasLoadedInitially {
            view?.setLoading(true)
            view?.fillFirstPage(with: [])
            loadFirstPage()
        }
    }

    func openCities() {
        onOpenCity?(city)
    }

    func openSort() {
        onOpenSort?(sort)
    }

    func openFilters() {
        onOpenFilters?(filters)
    }

}

// MARK: - OffersAdminViewOutput

extension OffersAdminPresenter: OffersAdminViewOutput {

    func viewLoaded() {
        city = try? .from(dto: basicStorage?.get(for: .defaultCity))
        adminPanelInput?.setOffersCity(city?.name ?? L10n.Localizable.SelectCity.allCities)
        adminPanelInput?.setOffersSort(sort == .default ? L10n.Localizable.Sort.placeholder : sort.description)
        adminPanelInput?.setOffersHasFilters(filters.isNotEmpty)

        view?.setLoading(true)
        loadFirstPage()
    }

    func search(query: String?) {
        self.query = query
        view?.setEmptyState(false)
        loadFirstPage()
    }

    func openOffer(_ id: Int) {
        onOpenOffer?(id)
    }

}

// MARK: - RefreshableOutput

extension OffersAdminPresenter: RefreshableOutput {

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

extension OffersAdminPresenter: PaginatableOutput {

    func onPaginationInitialized(with input: PaginatableInput) {
        paginatableInput = input
    }

    func loadNextPage(with input: PaginatableInput) {
        guard canLoadNext() else {
            return
        }
        input.updateProgress(isLoading: true)
        currentPage += 1

        fetchOffers {
            input.updateProgress(isLoading: false)
        } handleResult: { [weak self] result in
            switch result {
            case .success(let page):
                guard let self else {
                    return
                }
                pagesCount = page.pagination.totalPages
                updatePagination()
                view?.setEmptyState(page.data.isEmpty)
                view?.fillNextPage(with: page.data.map { self.makeOfferViewModel(from: $0) })
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

private extension OffersAdminPresenter {

    func makeOfferViewModel(
        from offer: BriefOfferEntity
    ) -> OfferAdminCollectionViewCell.ViewModel {
        let viewModel = OfferAdminCollectionViewCell.ViewModel(
            id: offer.id,
            loadImage: { [weak self] imageView in
                self?.loadImage(url: offer.photoUrl, imageView: imageView)
            },
            title: offer.title,
            description: offer.description,
            price: LocalizationHelper.pricePerDay(for: offer.price),
            location: offer.city,
            isBanned: offer.isBanned,
            banReason: offer.banReason,
            banAction: { [weak self] newValue, completion in
                self?.setOfferBan(id: offer.id, value: newValue) { completion?($0) }
            },
            deleteAction: { [weak self] handler in
                self?.deleteOffer(id: offer.id) { handler?($0) }
            }
        )
        return viewModel
    }
}

// MARK: - Network requests

private extension OffersAdminPresenter {

    func loadImage(url: URL?, imageView: UIImageView) {
        DispatchQueue.main.async {
            imageView.kf.setImage(with: url)
        }
    }

    func setOfferBan(id: Int, value: Bool, completion: ((Bool) -> Void)?) {
        completion?(true)
    }

    func deleteOffer(id: Int, completion: ((Bool) -> Void)?) {
        completion?(true)
    }

    func loadFirstPage(completion: (() -> Void)? = nil) {
        currentPage = 0
        paginationSnapshot = .now
        paginatableInput?.updatePagination(canIterate: false)
        paginatableInput?.updateProgress(isLoading: false)

        fetchOffers { [weak self] in
            self?.view?.setLoading(false)
            self?.paginatableInput?.updateProgress(isLoading: false)
            completion?()
        } handleResult: { [weak self] result in
            switch result {
            case .success(let page):
                guard let self else {
                    return
                }
                pagesCount = page.pagination.totalPages
                updatePagination()
                view?.setEmptyState(page.data.isEmpty)
                view?.fillFirstPage(with: page.data.compactMap { self.makeOfferViewModel(from: $0) })
                hasLoadedInitially = true
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
        if let fromPrice = filters.priceFilter.from {
            filtering.append(
                .init(filterKey: .price, operation: .greaterThanEqual, value: AnyEncodable(fromPrice.value))
            )
        }
        if let toPrice = filters.priceFilter.to {
            filtering.append(.init(filterKey: .price, operation: .lessThanEqual, value: AnyEncodable(toPrice.value)))
        }
        // TODO: Uncomment when server implements the feature
//        if let status = filters.statusFilter.toFilterEntity {
//            filtering.append(status)
//        }
        if let query, !query.isEmpty {
            let words = query.split(separator: " ").map { String($0) }
            for word in words {
                filtering.append(.init(filterKey: .title, operation: .contains, value: AnyEncodable(word)))
            }
        }
        let searchOffersEntity = SearchRequestEntity(
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
