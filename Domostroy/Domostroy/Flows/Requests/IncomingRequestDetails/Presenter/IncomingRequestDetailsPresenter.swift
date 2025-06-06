//
//  IncomingRequestDetailsPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 13/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation
import UIKit
import Combine
import NodeKit
import Kingfisher

final class IncomingRequestDetailsPresenter: IncomingRequestDetailsModuleOutput {

    // MARK: - IncomingRequestDetailsModuleOutput

    var onOpenOffer: ((Int) -> Void)?
    var onOpenUser: ((Int) -> Void)?
    var onDismiss: EmptyClosure?

    // MARK: - Properties

    weak var view: IncomingRequestDetailsViewInput?

    private var requestId: Int?
    private var requestEntity: RentalRequest1Entity?

    private let rentService: RentService? = ServiceLocator.shared.resolve()
    private var cancellables: Set<AnyCancellable> = .init()
}

// MARK: - IncomingRequestDetailsModuleInput

extension IncomingRequestDetailsPresenter: IncomingRequestDetailsModuleInput {

    func setRequestId(_ id: Int) {
        self.requestId = id
    }

}

// MARK: - IncomingRequestDetailsViewOutput

extension IncomingRequestDetailsPresenter: IncomingRequestDetailsViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
        loadRequest()
    }

    func openOffer() {
        guard let requestEntity else {
            return
        }
        onOpenOffer?(requestEntity.offerId)
    }

    func openUser() {
        guard let requestEntity else {
            return
        }
        onOpenUser?(requestEntity.userId)
    }

    func call() {
        guard let phoneNumber = requestEntity?.phoneNumber else {
            return
        }
        if let url = URL(string: "tel://\(phoneNumber)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    func accept() {
        guard let requestId else {
            return
        }
        view?.setAcceptingActivity(isLoading: true)
        rentService?.changeRequestStatus(
            id: requestId, status: .accepted
        ).sink(
            receiveCompletion: { [weak self] _ in
                self?.view?.setAcceptingActivity(isLoading: false)
            },
            receiveValue: { [weak self] result in
                switch result {
                case .success:
                    self?.loadRequest()
                case .failure(let error):
                    DropsPresenter.shared.showError(error: error)
                }
            }
        ).store(in: &cancellables)
    }

    func decline() {
        guard let requestId else {
            return
        }
        view?.setDecliningActivity(isLoading: true)
        rentService?.changeRequestStatus(
            id: requestId, status: .accepted
        ).sink(
            receiveCompletion: { [weak self] _ in
                self?.view?.setDecliningActivity(isLoading: false)
            },
            receiveValue: { [weak self] result in
                switch result {
                case .success:
                    self?.loadRequest()
                case .failure(let error):
                    DropsPresenter.shared.showError(error: error)
                }
            }
        ).store(in: &cancellables)
    }

}

// MARK: - Private methods

private extension IncomingRequestDetailsPresenter {

    func loadRequest() {
        view?.setLoading(true)
        fetchRequest(
            completion: { [weak self] in
                self?.view?.setLoading(false)
            },
            handleResult: { [weak self] result in
                guard let self else {
                    return
                }
                switch result {
                case .success(let request):
                    self.requestEntity = request
                    let viewModel = self.makeViewModel(from: request)
                    self.view?.configure(with: viewModel, moreActions: self.makeMoreActions(status: request.status))
                case .failure(let error):
                    DropsPresenter.shared.showError(error: error)
                    self.onDismiss?()
                }
            }
        )
    }

    func makeViewModel(from entity: RentalRequest1Entity) -> IncomingRequestDetailsView.ViewModel {
        let statusViewModel: RequestStatusView.Status
        switch entity.status {
        case .accepted:
            statusViewModel = .accepted(entity.resolvedAt)
        case .pending:
            statusViewModel = .pending
        case .declined:
            statusViewModel = .declined(entity.resolvedAt)
        }
        let offerViewModel = ConciseOfferView.ViewModel(
            imageUrl: entity.photoUrl,
            loadImage: { [weak self] url, imageView in
                self?.loadImage(url: url, imageView: imageView)
            },
            title: entity.title,
            price: LocalizationHelper.pricePerDay(for: entity.price)
        )
        let userViewModel = IncomingRequestDetailsView.ViewModel.User(
            username: entity.name,
            phoneNumber: RussianPhoneTextFieldFormatter.format(phoneNumber: entity.phoneNumber),
            imageUrl: nil,
            loadImage: { _, imageView in
                imageView.loadAvatar(id: entity.userId, name: entity.name, url: nil)
            }
        )
        var actions: [IncomingRequestDetailsView.ViewModel.Action] = []
        switch entity.status {
        case .accepted:
            actions.append(
                .init(
                    type: .filledPrimary,
                    title: L10n.Localizable.RequestDetails.Button.call,
                    action: { [weak self] in
                        self?.call()
                    }
                )
            )
        case .pending:
            actions.append(
                .init(
                    type: .filledPrimary,
                    title: L10n.Localizable.RequestDetails.Button.accept,
                    action: { [weak self] in
                        self?.accept()
                    }
                )
            )
            actions.append(
                .init(
                    type: .destructive,
                    title: L10n.Localizable.RequestDetails.Button.decline,
                    action: { [weak self] in
                        self?.decline()
                    }
                )
            )
        case .declined:
            break
        }
        return .init(
            offer: offerViewModel,
            status: statusViewModel,
            dates: "\(L10n.Localizable.RequestDetails.Info.dates): \(entity.dates.formattedDateRanges())",
            submissionDate: "\(L10n.Localizable.RequestDetails.Info.requestDate): \(entity.createdAt.toDMMYY())",
            user: userViewModel,
            actions: actions
        )
    }

    func makeMoreActions(status: RequestStatus) -> [UIAction] {
        let actions: [UIAction] = []
        switch status {
        case .accepted:
            break
        case .pending:
            break
        case .declined:
            break
        }
        return actions
    }

    func fetchRequest(completion: EmptyClosure?, handleResult: ((NodeResult<RentalRequest1Entity>) -> Void)?) {
        guard let requestId else {
            return
        }
        rentService?.getIncomingRequest(
            id: requestId
        ).sink(
            receiveCompletion: { _ in completion?() },
            receiveValue: { handleResult?($0) }
        ).store(in: &cancellables)
    }

    func loadImage(url: URL?, imageView: UIImageView) {
        DispatchQueue.main.async {
            imageView.kf.setImage(with: url)
        }
    }

}
