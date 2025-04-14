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

enum Sort {
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
    var onOpenFilters: ((Filter?) -> Void)?

    // MARK: - Properties

    typealias DiffableOfferGenerator = DiffableCollectionCellGenerator<OfferCollectionViewCell>

    weak var view: SearchViewInput?
    private weak var paginatableInput: PaginatableInput?

    var adapter: BaseCollectionManager?

    private var query: String?
    private var isFirstPageLoading = false
    private var pagesCount = 0
    private var currentPage = 0

    private var city: City?
    private var sort: Sort = .default
    private var filter: Filter = .init()

}

// MARK: - SearchModuleInput

extension SearchPresenter: SearchModuleInput {

    func set(query: String?) {
        self.query = query
        view?.set(query: self.query)
        loadFirstPage()
    }

    func set(city: City) {
        self.city = city
        view?.set(city: city.name)
        loadFirstPage()
    }

    func set(sort: Sort) {
        self.sort = sort
        view?.set(sort: sort.description)
        loadFirstPage()
    }

    func set(filter: Filter) {
        self.filter = filter
        // TODO: Check if empty
        view?.set(hasFilters: false)
        loadFirstPage()
    }
}

// MARK: - SearchViewOutput

extension SearchPresenter: SearchViewOutput {

    func viewLoaded() {
        city = .init(id: 0, name: "Воронеж")
        view?.set(city: city?.name)
        view?.set(sort: sort.description)
        filter = .init()
        view?.set(hasFilters: false)

        loadFirstPage()
    }

    func setSearch(active: Bool) {
        view?.setSearchOverlay(active: active)
    }

    func search(query: String?) {
        self.query = query
        loadFirstPage()
    }

    func cancelSearchFieldInput() {
        view?.set(query: self.query)
    }

    func openCity() {
        onOpenCity?(city)
    }

    func openSort() {
        onOpenSort?(sort)
    }

    func openFilters() {
        onOpenFilters?(filter)
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

// MARK: - Generators

private extension SearchPresenter {

    func makeGenerator(from offer: Offer) -> DiffableOfferGenerator {
        let viewModel = OfferCollectionViewCell.ViewModel(
            imageUrl: offer.images.first,
            loadImage: { [weak self] url, imageView in
                self?.loadImage(url: url, imageView: imageView)
            },
            title: offer.name,
            price: offer.price.stringDroppingTrailingZero,
            description: offer.description,
            user: OfferCollectionViewCell.ViewModel.UserViewModel(
                url: _Temporary_EndpointConstructor.user(id: offer.userId).url,
                loadUser: { [weak self] url, imageView, label in
                    self?.loadUser(url: url, imageView: imageView, label: label)
                }
            ),
            actions: [],
            toggleActions: [
                .init(
                    initialState: offer.isFavorite,
                    onImage: .Buttons.favoriteFilled,
                    offImage: .Buttons.favorite,
                    toggleAction: { [weak self] newValue, handler in
                        self?.setFavorite(id: offer.id, value: newValue) { success in
                            handler?(success)
                        }
                    }
                )
            ]
        )

        let generator = OfferCollectionViewCell.rddm.diffableGenerator(uniqueId: UUID(), with: viewModel, and: .class)
        generator.didSelectEvent += { [weak self] in
            self?.onOpenOffer?(offer.id)
        }
        return generator
    }
}

// MARK: - Network requests

private extension SearchPresenter {

    func loadImage(url: URL?, imageView: UIImageView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            imageView.kf.setImage(with: url, placeholder: UIImage.Mock.makita)
        }
    }

    func loadUser(url: URL?, imageView: UIImageView, label: UILabel) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            // TODO: Fetch user
            imageView.kf.setImage(with: url, placeholder: UIImage.Mock.makita)
            label.text = "Test user"
        }
    }

    func setFavorite(id: Int, value: Bool, completion: ((Bool) -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            completion?(false)
        }
    }

    func loadFirstPage() {
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

            let newGenerators = page.offers.map { self.makeGenerator(from: $0) }
            if let lastGenerator = self.adapter?.generators.last?.last {
                self.adapter?.insert(after: lastGenerator, new: newGenerators)
            } else {
                self.adapter?.addCellGenerators(newGenerators)
                self.adapter?.forceRefill()
            }
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

//            self.view?.setEmptyState(page.offers.isEmpty)
            self.adapter?.clearCellGenerators()
            self.adapter?.addCellGenerators(page.offers.map { self.makeGenerator(from: $0) })
            self.adapter?.forceRefill()
        }

        return currentPage < pagesCount
    }

}
