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

    // MARK: - Properties

    weak var view: IncomingRequestDetailsViewInput?

    private var requestId: Int?
    private var requestEntity: RentalRequestEntity?
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
        onOpenOffer?(requestEntity.offer.id)
    }

    func openUser() {
        guard let requestEntity else {
            return
        }
        onOpenUser?(requestEntity.user.id)
    }

    func call() {
        guard let phoneNumber = requestEntity?.user.phoneNumber else {
            return
        }
        if let url = URL(string: "tel://\(phoneNumber)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    func accept() {
        print("accept")
    }

    func decline() {
        print("decline")
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
                }
            }
        )
    }

    func makeViewModel(from entity: RentalRequestEntity) -> IncomingRequestDetailsView.ViewModel {
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
            imageUrl: entity.offer.photoUrl,
            loadImage: { [weak self] url, imageView in
                self?.loadImage(url: url, imageView: imageView)
            },
            title: entity.offer.title,
            price: LocalizationHelper.pricePerDay(for: entity.offer.price)
        )
        let userViewModel = IncomingRequestDetailsView.ViewModel.User(
            username: entity.user.name,
            phoneNumber: entity.user.phoneNumber,
            imageUrl: nil,
            loadImage: { _, imageView in
                imageView.image = .initialsAvatar(name: entity.user.name, hashable: entity.user.id)
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

    func fetchRequest(completion: EmptyClosure?, handleResult: ((NodeResult<RentalRequestEntity>) -> Void)?) {
        guard let requestId else {
            return
        }
        Task {
            let result = await _Temporary_Mock_NetworkService().fetchRentalRequest()
            DispatchQueue.main.async {
                completion?()
                handleResult?(result)
            }
        }
    }

    func loadImage(url: URL?, imageView: UIImageView) {
        DispatchQueue.main.async {
            imageView.kf.setImage(with: url)
        }
    }

}
