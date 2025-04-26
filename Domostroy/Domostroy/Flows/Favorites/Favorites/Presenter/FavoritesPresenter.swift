//
//  FavoritesPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation
import UIKit
import ReactiveDataDisplayManager
import Kingfisher

final class FavoritesPresenter: FavoritesModuleOutput {

    // MARK: - Constants

    private enum Constants {
        static let pageSize = 10
    }

    // MARK: - FavoritesModuleOutput

    var onOpenOffer: ((Int) -> Void)?
    var onOpenSort: ((Sort) -> Void)?

    // MARK: - Properties

    weak var view: FavoritesViewInput?
    private weak var paginatableInput: PaginatableInput?

    private var sort: Sort = .default

    private var isFirstPageLoading = false
    private var pagesCount = 0
    private var currentPage = 0

}

// MARK: - FavoritesModuleInput

extension FavoritesPresenter: FavoritesModuleInput {

    func setSort(_ sort: Sort) {
        self.sort = sort
        view?.setSort(sort == .default ? L10n.Localizable.Sort.placeholder : sort.description)
        loadFirstPage()
    }

}

// MARK: - FavoritesViewOutput

extension FavoritesPresenter: FavoritesViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
        loadFirstPage()
    }

    func openSort() {
        onOpenSort?(sort)
    }

    func openOffer(_ id: Int) {
        onOpenOffer?(id)
    }

}

// MARK: - RefreshableOutput

extension FavoritesPresenter: RefreshableOutput {

    func refreshContent(with input: RefreshableInput) {
        paginatableInput?.updatePagination(canIterate: false)
        paginatableInput?.updateProgress(isLoading: false)

        Task {
            let canIterate = await fillFirst()

            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }
                input.endRefreshing()
                self.view?.setSort(
                    self.pagesCount > 0 ?
                        sort == .default ?
                            L10n.Localizable.Sort.placeholder
                            : sort.description
                    : nil
                )
                self.paginatableInput?.updatePagination(canIterate: canIterate)
                self.paginatableInput?.updateProgress(isLoading: false)
            }
        }
    }

}

// MARK: - PaginatableOutput

extension FavoritesPresenter: PaginatableOutput {

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

private extension FavoritesPresenter {

    func makeOfferViewModel(
        from offer: Offer
    ) -> FavoriteOfferCollectionViewCell.ViewModel {
        let toggleActions: [FavoriteOfferCollectionViewCell.ViewModel.ToggleButtonModel] = [
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
        let userViewModel = FavoriteOfferCollectionViewCell.ViewModel.UserViewModel(
            url: _Temporary_EndpointConstructor.user(id: offer.userId).url) { [weak self] url, imageView, label in
                self?.loadUser(url: url, imageView: imageView, label: label)
        }
        let viewModel = FavoriteOfferCollectionViewCell.ViewModel(
            id: offer.id,
            imageUrl: offer.images.first,
            loadImage: { [weak self] url, imageView in
                self?.loadImage(url: url, imageView: imageView)
            },
            title: offer.name,
            // TODO: Localize
            price: "\(offer.price.stringDroppingTrailingZero)₽/день",
            description: offer.description,
            user: userViewModel,
            actions: [],
            toggleActions: toggleActions
        )
        return viewModel
    }
}

// MARK: - Network requests

private extension FavoritesPresenter {

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
        view?.fillFirstPage(with: [])
        view?.setLoading(true)
        paginatableInput?.updatePagination(canIterate: false)
        paginatableInput?.updateProgress(isLoading: false)

        Task {
            let canIterate = await fillFirst()

            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }
                self.view?.setLoading(false)
                self.paginatableInput?.updatePagination(canIterate: canIterate)
                self.paginatableInput?.updateProgress(isLoading: false)
                self.view?.setSort(
                    self.pagesCount > 0 ?
                        sort == .default ?
                            L10n.Localizable.Sort.placeholder
                            : sort.description
                    : nil
                )
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

}
