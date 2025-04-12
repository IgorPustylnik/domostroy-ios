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

final class HomePresenter: HomeModuleOutput {

    // MARK: - Constants

    private enum Constants {
        static let pageSize = 10
    }

    // MARK: - HomeModuleOutput

    var onOpenOffer: ((Int) -> Void)?
    var onSearch: ((String) -> Void)?

    // MARK: - Properties

    typealias DiffableOfferGenerator = DiffableCollectionCellGenerator<OfferCollectionViewCell>

    weak var view: HomeViewInput?
    private weak var paginatableInput: PaginatableInput?

    var adapter: BaseCollectionManager?

    private var isFirstPageLoading = true
    private var pagesCount = 0
    private var currentPage = 0

    private var offers: [Offer] = []

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
        guard let query else {
            return
        }
        onSearch?(query)
    }

}

// MARK: - RefreshableOutput

extension HomePresenter: RefreshableOutput {

    func refreshContent(with input: RefreshableInput) {
        Task {
            let page = await _Temporary_Mock_NetworkService().fetchOffers(page: 0, pageSize: Constants.pageSize)
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }
                self.offers = page.offers
                self.currentPage = page.pagination.currentPage
                self.pagesCount = page.pagination.totalPages

                self.adapter?.clearCellGenerators()
                self.adapter?.addCellGenerators(self.offers.map { self.makeGenerator(from: $0) })
                self.adapter?.forceRefill()

                input.endRefreshing()
            }
        }
    }

}

// MARK: - PaginatableOutput

extension HomePresenter: PaginatableOutput {

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

private extension HomePresenter {

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

private extension HomePresenter {

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

        do {
            let page = await _Temporary_Mock_NetworkService().fetchOffers(page: currentPage, pageSize: Constants.pageSize)

            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }

                var newGenerators = [CollectionCellGenerator]()
                let newOffers = page.offers
                self.offers = newOffers
                self.currentPage = page.pagination.currentPage
                self.pagesCount = page.pagination.totalPages
                self.isFirstPageLoading = false

                newGenerators = newOffers.map { self.makeGenerator(from: $0) }

                self.paginatableInput?.updateProgress(isLoading: false)
                self.paginatableInput?.updatePagination(canIterate: true)

                if let lastGenerator = self.adapter?.generators.last?.last {
                    self.adapter?.insert(after: lastGenerator, new: newGenerators)
                } else {
                    self.adapter?.addCellGenerators(newGenerators)
                    self.adapter?.forceRefill()
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.paginatableInput?.updateProgress(isLoading: false)
                self.paginatableInput?.updateError(error)
            }
        }

        return currentPage < pagesCount
    }

    func loadFirstPage() {
        // TODO: Localize
        adapter?.addSectionHeaderGenerator(TitleCollectionHeaderGenerator(title: "Recommended"))
        view?.showLoader()

        paginatableInput?.updatePagination(canIterate: false)
        paginatableInput?.updateProgress(isLoading: false)

        Task {
            do {
                let page = await _Temporary_Mock_NetworkService().fetchOffers(page: 0, pageSize: 10)

                DispatchQueue.main.async {
                    self.offers = page.offers
                    self.currentPage = page.pagination.currentPage
                    self.pagesCount = page.pagination.totalPages
                    self.isFirstPageLoading = false

                    self.adapter?.clearCellGenerators()
                    self.adapter?.addCellGenerators(self.offers.map { self.makeGenerator(from: $0) })
                    self.adapter?.forceRefill()

                    self.view?.hideLoader()
                    self.paginatableInput?.updatePagination(canIterate: true)
                    self.paginatableInput?.updateProgress(isLoading: false)
                }
            } catch {
                DispatchQueue.main.async {
                    self.view?.hideLoader()
                    self.paginatableInput?.updateProgress(isLoading: false)
                    self.paginatableInput?.updateError(error)
                }
            }
        }
    }

}
