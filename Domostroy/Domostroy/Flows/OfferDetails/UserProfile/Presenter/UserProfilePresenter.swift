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
import Combine
import NodeKit

final class UserProfilePresenter: UserProfileModuleOutput {

    // MARK: - Constants

    private enum Constants {
        static let pageSize = 10
    }

    // MARK: - UserProfileModuleOutput

    var onOpenOffer: ((Int) -> Void)?
    var onDismiss: EmptyClosure?

    // MARK: - Properties

    weak var view: UserProfileViewInput?
    private weak var paginatableInput: PaginatableInput?

    private let secureStorage: SecureStorage? = ServiceLocator.shared.resolve()
    private var userService: UserService? = ServiceLocator.shared.resolve()
    private var offerService: OfferService? = ServiceLocator.shared.resolve()
    private var cancellables: Set<AnyCancellable> = .init()

    private var userId: Int?

    private var isFirstPageLoading = false
    private var pagesCount = 0
    private var currentPage = 0
    private var paginationSnapshot: Date = .now
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
        view?.setLoading(true)
        loadFirstPage()
    }

    func openOffer(_ id: Int) {
        onOpenOffer?(id)
    }

}

// MARK: - RefreshableOutput

extension UserProfilePresenter: RefreshableOutput {

    func refreshContent(with input: RefreshableInput) {
        loadFirstPage {
            input.endRefreshing()
        }
    }

}

// MARK: - PaginatableOutput

extension UserProfilePresenter: PaginatableOutput {

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
                self.pagesCount = page.pagination.totalPages
                self.updatePagination()
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

private extension UserProfilePresenter {

    func makeUserViewModel(
        from user: UserEntity
    ) -> UserProfileInfoCollectionViewCell.ViewModel {
        return .init(
            imageUrl: nil,
            loadImage: { url, imageView in
               imageView.loadAvatar(id: user.id, name: user.name, url: url)
            },
            username: user.name,
            info1: "\(user.offersAmount) \(L10n.Plurals.offer(user.offersAmount))",
            info2: RussianPhoneTextFieldFormatter.format(phoneNumber: user.phoneNumber),
            info3: L10n.Localizable.UserProfile.registrationDate(user.registrationDate.monthAndYearString())
        )
    }

    func makeOfferViewModel(
        from offer: BriefOfferEntity
    ) -> OfferCollectionViewCell.ViewModel {
        var toggleActions: [OfferCollectionViewCell.ViewModel.ToggleButtonModel] = []
        if secureStorage?.loadToken() != nil {
            toggleActions.append(
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
            )
        }
        let viewModel = OfferCollectionViewCell.ViewModel(
            id: offer.id,
            imageUrl: offer.photoUrl,
            loadImage: { url, imageView in
                DispatchQueue.main.async {
                    imageView.kf.setImage(with: url)
                }
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

    func setFavorite(id: Int, value: Bool, completion: ((Bool) -> Void)?) {
        offerService?.setFavorite(id: id, value: value)
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
        isFirstPageLoading = true
        paginatableInput?.updatePagination(canIterate: false)
        paginatableInput?.updateProgress(isLoading: false)

        fetchOffers { [weak self] in
            self?.view?.setLoading(false)
            self?.paginatableInput?.updateProgress(isLoading: false)

            self?.fetchUser(completion: nil) { [weak self] result in
                guard let self else {
                    return
                }
                switch result {
                case .success(let user):
                    self.view?.fillUser(with: self.makeUserViewModel(from: user))
                case .failure(let error):
                    self.onDismiss?()
                    DropsPresenter.shared.showError(error: error)
                }
            }

            completion?()
        } handleResult: { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(let page):
                self.pagesCount = page.pagination.totalPages
                self.updatePagination()
                self.isFirstPageLoading = false
                self.view?.fillFirstPage(with: page.data.map { self.makeOfferViewModel(from: $0) })

            case .failure(let error):
                DropsPresenter.shared.showError(error: error)
            }
        }
    }

    func fetchUser(
        completion: EmptyClosure?,
        handleResult: ((NodeResult<UserEntity>) -> Void)?
    ) {
        guard let userId else {
            return
        }
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

    func fetchOffers(
        completion: EmptyClosure?,
        handleResult: ((NodeResult<PageEntity<BriefOfferEntity>>) -> Void)?
    ) {
        let searchOffersEntity = SearchRequestEntity(
            pagination: .init(page: currentPage, size: CommonConstants.pageSize),
            sorting: [.init(property: .date, direction: .descending)],
            searchCriteriaList: [.init(filterKey: .userId, operation: .equals, value: AnyEncodable(userId))],
            snapshot: paginationSnapshot,
            seed: nil
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
        if currentPage < pagesCount {
            return true
        }
        return false
    }

}
