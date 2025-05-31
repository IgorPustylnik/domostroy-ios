//
//  OutgoingRequestDetailsPresenter.swift
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

final class OutgoingRequestDetailsPresenter: OutgoingRequestDetailsModuleOutput {

    // MARK: - OutgoingRequestDetailsModuleOutput

    var onOpenOffer: ((Int) -> Void)?
    var onOpenUser: ((Int) -> Void)?
    var onDismiss: EmptyClosure?

    // MARK: - Properties

    weak var view: OutgoingRequestDetailsViewInput?

    private var requestId: Int?
    private var requestEntity: RentalRequest1Entity?

    private let rentService: RentService? = ServiceLocator.shared.resolve()
    private var cancellables: Set<AnyCancellable> = .init()
}

// MARK: - OutgoingRequestDetailsModuleInput

extension OutgoingRequestDetailsPresenter: OutgoingRequestDetailsModuleInput {

    func setRequestId(_ id: Int) {
        self.requestId = id
    }

}

// MARK: - OutgoingRequestDetailsViewOutput

extension OutgoingRequestDetailsPresenter: OutgoingRequestDetailsViewOutput {

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

    func cancelRent() {
        deleteRequest()
    }

    func cancelRequest() {
        deleteRequest()
    }

}

// MARK: - Private methods

private extension OutgoingRequestDetailsPresenter {

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

    func deleteRequest() {
        guard let requestId else {
            return
        }
        let loading = DLoadingOverlay.shared.show()
        loading.cancellable.store(in: &cancellables)
        rentService?.deleteRentRequest(
            id: requestId
        ).sink(
            receiveCompletion: { _ in
                DLoadingOverlay.shared.hide(id: loading.id)
            },
            receiveValue: { [weak self] result in
                switch result {
                case .success:
                    self?.onDismiss?()
                case .failure(let error):
                    DropsPresenter.shared.showError(error: error)
                }
            }
        ).store(in: &cancellables)
    }

    func makeViewModel(from entity: RentalRequest1Entity) -> OutgoingRequestDetailsView.ViewModel {
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
        let userViewModel = OutgoingRequestDetailsView.ViewModel.User(
            username: entity.name,
            phoneNumber: RussianPhoneTextFieldFormatter.format(phoneNumber: entity.phoneNumber),
            imageUrl: nil,
            loadImage: { url, imageView in
                imageView.loadAvatar(id: entity.userId, name: entity.name, url: url)
            }
        )
        var actions: [OutgoingRequestDetailsView.ViewModel.Action] = []
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
            break
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
        var actions: [UIAction] = []
        switch status {
        case .accepted:
            actions.append(
                .init(
                    title: L10n.Localizable.RequestDetails.Menu.Button.cancelRent,
                    attributes: .destructive,
                    handler: { [weak self] _ in
                        self?.cancelRent()
                    }
                )
            )
        case .pending:
            actions.append(
                .init(
                    title: L10n.Localizable.RequestDetails.Menu.Button.cancelRequest,
                    attributes: .destructive,
                    handler: { [weak self] _ in
                        self?.cancelRequest()
                    }
                )
            )
        case .declined:
            break
        }
        return actions
    }

    func fetchRequest(completion: EmptyClosure?, handleResult: ((NodeResult<RentalRequest1Entity>) -> Void)?) {
        guard let requestId else {
            return
        }
        rentService?.getOutgoingRequest(
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
