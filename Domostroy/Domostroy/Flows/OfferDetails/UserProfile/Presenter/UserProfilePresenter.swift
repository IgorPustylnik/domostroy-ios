//
//  UserProfilePresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 24/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager
import Kingfisher

final class UserProfilePresenter: UserProfileModuleOutput {

    // MARK: - Constants

    private enum Constants {
        static let pageSize = 10
    }

    // MARK: - UserProfileModuleOutput

    var onOpenOffer: ((Int) -> Void)?
    var onSearch: ((String?) -> Void)?

    // MARK: - Properties

    weak var view: UserProfileViewInput?
    private weak var paginatableInput: PaginatableInput?

    private var userId: Int?

    private var isFirstPageLoading = false
    private var pagesCount = 0
    private var currentPage = 0
}

// MARK: - UserProfileModuleInput

extension UserProfilePresenter: UserProfileModuleInput {
    func setUserId(_ id: Int) {
        self.userId = id
    }
}

// MARK: - UserProfileViewOutput

extension UserProfilePresenter: UserProfileViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
        loadFirstPage()
    }

    func openOffer(_ id: Int) {
        onOpenOffer?(id)
    }

}

// MARK: - RefreshableOutput

extension UserProfilePresenter: RefreshableOutput {

    func refreshContent(with input: RefreshableInput) {
        guard let userId else {
            return
        }

        paginatableInput?.updatePagination(canIterate: false)
        paginatableInput?.updateProgress(isLoading: false)

        Task {
            async let _ = fillUser(userId: userId)
            async let canIterateTask = fillFirst(userId: userId)

            let canIterate = await canIterateTask

            DispatchQueue.main.async { [weak self] in
                input.endRefreshing()
                self?.paginatableInput?.updatePagination(canIterate: canIterate)
                self?.paginatableInput?.updateProgress(isLoading: false)
            }
        }
    }

}

// MARK: - PaginatableOutput

extension UserProfilePresenter: PaginatableOutput {

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

private extension UserProfilePresenter {

    func makeUserViewModel(
        from user: User
    ) -> UserProfileInfoCollectionViewCell.ViewModel {
        return .init(
            imageUrl: user.avatar,
            loadImage: { [weak self] url, imageView in
                self?.loadImage(url: url, imageView: imageView)
            },
            username: user.firstName,
            info1: "\(user.offersAmount) \(L10n.Plurals.offer(user.offersAmount))",
            info2: L10n.Localizable.UserProfile.registrationDate(user.registerDate.monthAndYearString())
        )
    }

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

private extension UserProfilePresenter {

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
        guard let userId else {
            return
        }
        view?.setLoading(true)
        paginatableInput?.updatePagination(canIterate: false)
        paginatableInput?.updateProgress(isLoading: false)

        Task {
            async let _ = fillUser(userId: userId)
            async let canIterateTask = fillFirst(userId: userId)

            let canIterate = await canIterateTask

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

    func fillFirst(userId: Int) async -> Bool {
        isFirstPageLoading = true

        let page = await _Temporary_Mock_NetworkService().fetchOffers(page: 0, pageSize: Constants.pageSize)

        currentPage = page.pagination.currentPage
        pagesCount = page.pagination.totalPages
        isFirstPageLoading = false

        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            self.view?.fillFirstPage(with: page.offers.map { self.makeOfferViewModel(from: $0) })
        }

        return currentPage < pagesCount
    }

    func fillUser(userId: Int) async {
        let user = await _Temporary_Mock_NetworkService().fetchUser(id: userId)

        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            self.view?.fillUser(with: self.makeUserViewModel(from: user))
        }
    }

}
