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

    private var isFirstPageLoading = false
    private var pagesCount = 0
    private var currentPage = 0

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

extension MyOffersPresenter: PaginatableOutput {

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

private extension MyOffersPresenter {

    func makeOfferViewModel(
        from offer: Offer
    ) -> OwnOfferCollectionViewCell.ViewModel {
        let actions = [OwnOfferCollectionViewCell.ViewModel.ActionButtonModel(
            image: .Buttons.edit.withTintColor(.Domostroy.primary, renderingMode: .alwaysOriginal),
            action: { [weak self] in
                self?.onEditOffer?(offer.id)
            }
        )]
        let viewModel = OwnOfferCollectionViewCell.ViewModel(
            id: offer.id,
            imageUrl: offer.images.first,
            loadImage: { [weak self] url, imageView in
                self?.loadImage(url: url, imageView: imageView)
            },
            title: offer.name,
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
