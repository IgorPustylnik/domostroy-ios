//
//  UsersAdminPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 21/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import ReactiveDataDisplayManager
import Combine
import NodeKit

final class UsersAdminPresenter: UsersAdminModuleOutput {

    // MARK: - RequestsModuleOutput

    var onOpenUser: ((Int) -> Void)?

    func getSearchQuery() -> String? {
        query
    }

    // MARK: - Properties

    weak var view: UsersAdminViewInput?
    private weak var paginatableInput: PaginatableInput?

    private let adminService: AdminService? = ServiceLocator.shared.resolve()
    private var cancellables: Set<AnyCancellable> = .init()

    private var isFirstPageLoading = false
    private var pagesCount = 0
    private var currentPage = 0
    private var paginationSnapshot: Date = .now
    private var query: String?
}

// MARK: - UsersAdminModuleInput

extension UsersAdminPresenter: UsersAdminModuleInput {
    func search(_ query: String?) {
        self.query = query
    }
}

// MARK: - UsersAdminViewOutput

extension UsersAdminPresenter: UsersAdminViewOutput {

    func viewLoaded() {
        view?.setLoading(true)
        loadFirstPage()
    }

    func openUser(id: Int) {
        onOpenUser?(id)
    }

}

// MARK: - RefreshableOutput

extension UsersAdminPresenter: RefreshableOutput {
    func refreshContent(with input: RefreshableInput) {
        loadFirstPage {
            input.endRefreshing()
        }
    }
}

// MARK: - PaginatableOutput

extension UsersAdminPresenter: PaginatableOutput {
    func onPaginationInitialized(with input: PaginatableInput) {
        paginatableInput = input
    }

    func loadNextPage(with input: PaginatableInput) {
        guard canLoadNext() else {
            return
        }
        input.updateProgress(isLoading: true)
        currentPage += 1

        fetchUsers {
            input.updateProgress(isLoading: false)
        } handleResult: { [weak self] result in
            switch result {
            case .success(let page):
                guard let self else {
                    return
                }
                self.pagesCount = page.totalPages
                self.updatePagination()
                self.view?.fillNextPage(with: page.content.map { self.makeUserViewModel(from: $0) })
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

private extension UsersAdminPresenter {

    func makeUserViewModel(
        from user: UserDetailsEntity
    ) -> UserAdminCollectionViewCell.ViewModel {
        let viewModel = UserAdminCollectionViewCell.ViewModel(
            id: user.id,
            loadImage: { imageView, completion in
                imageView.loadAvatar(id: user.id, name: user.name, url: nil)
                completion()
            },
            name: "\(user.name)\(user.role == .admin ? " (\(L10n.Localizable.AdminPanel.Users.admin))" : "")",
            email: user.email,
            phoneNumber: RussianPhoneTextFieldFormatter().format(text: user.phoneNumber),
            registrationDate: L10n.Localizable.AdminPanel.Users.registrationDate(
                user.registrationDate.monthAndYearString()
            ),
            offersAmount: "\(user.offersAmount) \(L10n.Plurals.offer(user.offersAmount))",
            isBanned: user.isBanned,
            isAdmin: user.role == .admin,
            banAction: { [weak self] newValue, completion in
                self?.setBanned(userId: user.id, value: newValue) { completion?($0) }
            },
            deleteAction: { [weak self] completion in
                self?.delete(userId: user.id) { success in
                    completion?(success)
                }
            }
        )
        return viewModel
    }
}

// MARK: - Private methods

private extension UsersAdminPresenter {

    func loadImage(url: URL?, imageView: UIImageView) {
        DispatchQueue.main.async {
            imageView.kf.setImage(with: url)
        }
    }

    func setBanned(userId: Int, value: Bool, completion: ((Bool) -> Void)?) {
        let loading = DLoadingOverlay.shared.show()
        loading.cancellable.store(in: &cancellables)
        self.adminService?.setUserBan(
            id: userId,
            value: value
        ).sink(
            receiveCompletion: { _ in
                DLoadingOverlay.shared.hide(id: loading.id)
            },
            receiveValue: { result in
                switch result {
                case .success:
                    completion?(true)
                case .failure(let error):
                    completion?(false)
                    DropsPresenter.shared.showError(error: error)
                }
            }
        ).store(in: &cancellables)
    }

    func delete(userId: Int, completion: ((Bool) -> Void)?) {
        let loading = DLoadingOverlay.shared.show()
        loading.cancellable.store(in: &cancellables)
        self.adminService?.deleteUser(
            id: userId
        ).sink(
            receiveCompletion: { _ in
                DLoadingOverlay.shared.hide(id: loading.id)
            },
            receiveValue: { [weak self] result in
                switch result {
                case .success:
                    completion?(true)
                    self?.view?.fillFirstPage(with: [])
                    self?.loadFirstPage()
                case .failure(let error):
                    completion?(false)
                    DropsPresenter.shared.showError(error: error)
                }
            }
        ).store(in: &cancellables)
    }

    func loadFirstPage(completion: (() -> Void)? = nil) {
        currentPage = 0
        paginationSnapshot = .now
        paginatableInput?.updatePagination(canIterate: false)
        paginatableInput?.updateProgress(isLoading: false)
        view?.setEmptyState(false)
        isFirstPageLoading = true

        fetchUsers { [weak self] in
            self?.view?.setLoading(false)
            self?.paginatableInput?.updateProgress(isLoading: false)
            self?.isFirstPageLoading = false
            completion?()
        } handleResult: { [weak self] result in
            switch result {
            case .success(let page):
                guard let self else {
                    return
                }
                DispatchQueue.main.async {
                    self.pagesCount = page.totalPages
                    self.updatePagination()
                    self.view?.setEmptyState(page.content.isEmpty)
                    self.view?.fillFirstPage(
                        with: page.content.compactMap { self.makeUserViewModel(from: $0) }
                    )
                }
            case .failure(let error):
                DropsPresenter.shared.showError(error: error)
            }
        }
    }

    func fetchUsers(
        completion: EmptyClosure?,
        handleResult: ((NodeResult<Page1Entity<UserDetailsEntity>>) -> Void)?
    ) {
        adminService?.getUsers(
            searchQuery: query,
            paginationEntity: .init(page: currentPage, size: CommonConstants.pageSize)
        ).sink(
            receiveCompletion: { _ in completion?() },
            receiveValue: { handleResult?($0) }
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
