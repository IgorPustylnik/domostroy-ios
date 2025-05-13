//
//  IncomingRequestDetailsViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 13/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class IncomingRequestDetailsViewController: ScrollViewController {

    // MARK: - Properties

    private lazy var moreButton = {
        $0.showsMenuAsPrimaryAction = true
        $0.image = .NavigationBar.moreOutline.withTintColor(.Domostroy.primary, renderingMode: .alwaysOriginal)
        $0.insets = .zero
        $0.isHidden = true
        return $0
    }(DButton(type: .plainPrimary))

    private var incomingRequestDetailsView = IncomingRequestDetailsView()

    var output: IncomingRequestDetailsViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
    }

    override func loadView() {
        super.loadView()
        contentView = incomingRequestDetailsView
        contentView.isHidden = true
        incomingRequestDetailsView.onOpenOffer = { [weak self] in
            self?.output?.openOffer()
        }
        incomingRequestDetailsView.onOpenUser = { [weak self] in
            self?.output?.openUser()
        }
    }
}

// MARK: - IncomingRequestDetailsViewInput

extension IncomingRequestDetailsViewController: IncomingRequestDetailsViewInput {

    func setupInitialState() {
        scrollView.alwaysBounceVertical = true
        hidesTabBar = true
        navigationBar.title = L10n.Localizable.RequestDetails.Incoming.title
        navigationBar.rightItems = [moreButton]
    }

    func configure(with viewModel: IncomingRequestDetailsView.ViewModel, moreActions: [UIAction]) {
        contentView.isHidden = false
        incomingRequestDetailsView.configure(with: viewModel)
        moreButton.isHidden = moreActions.isEmpty
        moreButton.menu = .init(children: moreActions)
    }

}
