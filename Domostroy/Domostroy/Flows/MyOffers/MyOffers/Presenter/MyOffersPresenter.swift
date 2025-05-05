//
//  MyOffersPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation
import UIKit
import ReactiveDataDisplayManager
import Combine
import NodeKit

final class MyOffersPresenter: MyOffersModuleOutput {

    // MARK: - Constants

    private enum Constants {
        static let pageSize = 10
    }

    // MARK: - MyOffersModuleOutput

    var onOpenOffer: ((Int) -> Void)?
    var onEditOffer: ((Int) -> Void)?
    var onAdd: EmptyClosure?
    var onSetCenterControlEnabled: ((Bool) -> Void)? {
        didSet {
            onSetCenterControlEnabled?(isCenterControlEnabled)
        }
    }

    // MARK: - Properties

    weak var view: MyOffersViewInput?
    private weak var paginatableInput: PaginatableInput?

    private var offerService: OfferService? = ServiceLocator.shared.resolve()
    private var cancellables: Set<AnyCancellable> = .init()

    private var isFirstPageLoading = false
    private var pagesCount = 0
    private var currentPage = 0
    private var paginationSnapshot: Date = .now

    private var isCenterControlEnabled: Bool = true {
        didSet {
            onSetCenterControlEnabled?(isCenterControlEnabled)
        }
    }

}

// MARK: - MyOffersViewOutput

extension MyOffersPresenter: MyOffersViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
        loadFirstPage()
    }

    func openOffer(_ id: Int) {
        onOpenOffer?(id)
    }

}

// MARK: - MyOffersModuleInput

extension MyOffersPresenter: MyOffersModuleInput {

    func didTapCenterControl() {
        onAdd?()
    }

}

// MARK: - RefreshableOutput

extension MyOffersPresenter: RefreshableOutput {

    func refreshContent(with input: RefreshableInput) {
        loadFirstPage {
            input.endRefreshing()
        }
    }
}

// MARK: - PaginatableOutput

extension MyOffersPresenter: PaginatableOutput {

    func onPaginationInitialized(with input: PaginatableInput) {
        paginatableInput = input
    }

    func loadNextPage(with input: PaginatableInput) {
        guard canLoadNext() else {
            return
        }
        currentPage += 1
        input.updateProgress(isLoading: true)

        fetchOffers { [weak self] in
            self?.updatePagination()
            input.updateProgress(isLoading: false)
        } handleResult: { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(let page):
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

private extension MyOffersPresenter {

    func makeOfferViewModel(
        from offer: MyOfferEntity
    ) -> OwnOfferCollectionViewCell.ViewModel {
        let actions = [OwnOfferCollectionViewCell.ViewModel.ActionButtonModel(
            image: .Buttons.edit.withTintColor(.Domostroy.primary, renderingMode: .alwaysOriginal),
            action: { [weak self] in
                self?.onEditOffer?(offer.id)
            }
        )]
        let viewModel = OwnOfferCollectionViewCell.ViewModel(
            id: offer.id,
            imageUrl: offer.photoUrl,
            loadImage: { [weak self] url, imageView in
                self?.loadImage(url: url, imageView: imageView)
            },
            title: offer.title,
            price: LocalizationHelper.pricePerDay(for: offer.price),
            description: offer.description,
            createdAt: L10n.Localizable.Offers.publishedAt(offer.createdAt.toDMMYY()),
            actions: actions
        )
        return viewModel
    }
}

// MARK: - Network requests

private extension MyOffersPresenter {

    func loadImage(url: URL?, imageView: UIImageView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            imageView.kf.setImage(with: url, placeholder: UIImage.Mock.makita)
        }
    }

    func loadFirstPage(completion: (() -> Void)? = nil) {
        currentPage = 0
        paginationSnapshot = .now
        isFirstPageLoading = true
        view?.setLoading(true)
        paginatableInput?.updatePagination(canIterate: false)
        paginatableInput?.updateProgress(isLoading: false)

        fetchOffers { [weak self] in
            self?.view?.setLoading(false)
            self?.updatePagination()
            self?.paginatableInput?.updateProgress(isLoading: false)
            completion?()
        } handleResult: { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(let page):
                self.pagesCount = page.pagination.totalPages
                self.isFirstPageLoading = false
                self.view?.fillFirstPage(with: page.data.map { self.makeOfferViewModel(from: $0) })

            case .failure(let error):
                DropsPresenter.shared.showError(error: error)
            }
        }
    }

    func fetchOffers(
        completion: EmptyClosure?,
        handleResult: ((NodeResult<PageEntity<MyOfferEntity>>) -> Void)?
    ) {
        offerService?.getMyOffers(
        )
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
