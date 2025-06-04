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
import Combine
import NodeKit

final class FavoritesPresenter: FavoritesModuleOutput {

    // MARK: - Constants

    private enum Constants {
        static let pageSize = 10
    }

    // MARK: - FavoritesModuleOutput

    var onOpenOffer: ((Int) -> Void)?
    var onOpenSort: ((SortViewModel) -> Void)?

    // MARK: - Properties

    weak var view: FavoritesViewInput?
    private weak var paginatableInput: PaginatableInput?

    private var offerService: OfferService? = ServiceLocator.shared.resolve()
    private var userService: UserService? = ServiceLocator.shared.resolve()
    private var cancellables: Set<AnyCancellable> = .init()

    private var sort: SortViewModel = .default

    private var isFirstPageLoading = false
    private var pagesCount = 0
    private var currentPage = 0
    private var paginationSnapshot: Date = .now

}

// MARK: - FavoritesModuleInput

extension FavoritesPresenter: FavoritesModuleInput {

    func setSort(_ sort: SortViewModel) {
        self.sort = sort
        view?.setSort(sort == .default ? L10n.Localizable.Sort.placeholder : sort.description)
        view?.setLoading(true)
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
        loadFirstPage {
            input.endRefreshing()
        }
    }

}

// MARK: - PaginatableOutput

extension FavoritesPresenter: PaginatableOutput {

    func onPaginationInitialized(with input: PaginatableInput) {
        paginatableInput = input
    }

    func loadNextPage(with input: PaginatableInput) {
        guard canLoadNext() else {
            return
        }
        currentPage += 1
        input.updateProgress(isLoading: true)

        fetchOffers {
            input.updateProgress(isLoading: false)
        } handleResult: { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(let page):
                self.pagesCount = page.totalPages
                self.updatePagination()
                self.view?.fillNextPage(with: page.content.map { self.makeOfferViewModel(from: $0) })
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

private extension FavoritesPresenter {

    func makeOfferViewModel(
        from offer: FavoriteOfferEntity
    ) -> FavoriteOfferCollectionViewCell.ViewModel {
        let toggleActions: [FavoriteOfferCollectionViewCell.ViewModel.ToggleButtonModel] = [
            .init(
                initialState: true,
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
            id: offer.userId) { [weak self] id, imageView, label in
                self?.loadUser(id: id, imageView: imageView, nameLabel: label)
        }
        let viewModel = FavoriteOfferCollectionViewCell.ViewModel(
            id: offer.id,
            imageUrl: offer.photoUrl,
            loadImage: { [weak self] url, imageView in
                self?.loadImage(url: url, imageView: imageView)
            },
            title: offer.title,
            price: LocalizationHelper.pricePerDay(for: offer.price),
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
        DispatchQueue.main.async {
            imageView.kf.setImage(with: url)
        }
    }

    func loadUser(id: Int, imageView: UIImageView, nameLabel: UILabel) {
        fetchUser(
            userId: id,
            completion: nil
        ) { result in
            switch result {
            case .success(let user):
                nameLabel.text = user.name
                DispatchQueue.main.async {
                    imageView.loadAvatar(id: user.id, name: user.name, url: nil)
                }
            case .failure:
                break
            }
        }
    }

    func setFavorite(id: Int, value: Bool, completion: ((Bool) -> Void)?) {
        offerService?.setFavorite(
            id: id, value: value
        )
        .sink(receiveValue: { result in
            switch result {
            case .success:
                if value {
                    AnalyticsEvent.offerAddedToFavorites(offerId: id.description).send()
                }
                completion?(true)
            case .failure(let error):
                completion?(false)
                DropsPresenter.shared.showError(error: error)
            }
        })
        .store(in: &cancellables)
    }

    func loadFirstPage(completion: (() -> Void)? = nil) {
        currentPage = 0
        paginationSnapshot = .now
        isFirstPageLoading = true
        paginatableInput?.updatePagination(canIterate: false)
        paginatableInput?.updateProgress(isLoading: false)
        view?.setEmptyState(false)

        fetchOffers { [weak self] in
            self?.view?.setLoading(false)
            self?.paginatableInput?.updateProgress(isLoading: false)
            self?.isFirstPageLoading = false
            completion?()
        } handleResult: { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(let page):
                self.pagesCount = page.totalPages
                self.updatePagination()
                self.view?.fillFirstPage(with: page.content.map { self.makeOfferViewModel(from: $0) })
                self.view?.setEmptyState(page.totalElements < 1)
                self.view?.setSort(
                    page.totalElements > 0 ?
                        sort == .default ?
                            L10n.Localizable.Sort.placeholder
                            : sort.description
                        : nil
                )

            case .failure(let error):
                DropsPresenter.shared.showError(error: error)
            }
        }
    }

    func fetchOffers(
        completion: EmptyClosure?,
        handleResult: ((NodeResult<Page1Entity<FavoriteOfferEntity>>) -> Void)?
    ) {
        let startTime = Date()
        offerService?.getFavoriteOffers(
            paginationEntity: .init(
                page: currentPage,
                size: CommonConstants.pageSize
            ),
            sortEntity: sort.toSortEntity
        )
        .sink(
            receiveCompletion: { _ in
                completion?()
            },
            receiveValue: { result in
                handleResult?(result)
                AnalyticsEvent.offersLoaded(loadTime: Date().timeIntervalSince(startTime), source: "Favorites").send()
            }
        )
        .store(in: &cancellables)
    }

    func fetchUser(
        userId: Int,
        completion: EmptyClosure?,
        handleResult: ((NodeResult<UserEntity>) -> Void)?
    ) {
        userService?.getUser(id: userId)
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
        if currentPage < pagesCount {
            return true
        }
        return false
    }

}
