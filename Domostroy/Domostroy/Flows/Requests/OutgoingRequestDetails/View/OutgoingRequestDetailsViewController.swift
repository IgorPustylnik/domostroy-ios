//
//  OutgoingRequestDetailsViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 13/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class OutgoingRequestDetailsViewController: ScrollViewController {

    // MARK: - Properties

    private lazy var moreButton = {
        $0.showsMenuAsPrimaryAction = true
        $0.image = .NavigationBar.moreOutline.withTintColor(.Domostroy.primary, renderingMode: .alwaysOriginal)
        $0.insets = .zero
        $0.isHidden = true
        return $0
    }(DButton(type: .plainPrimary))

    private var outgoingRequestDetailsView = OutgoingRequestDetailsView()

    var output: OutgoingRequestDetailsViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
    }

    override func loadView() {
        super.loadView()
        contentView = outgoingRequestDetailsView
        contentView.isHidden = true
        outgoingRequestDetailsView.onOpenOffer = { [weak self] in
            self?.output?.openOffer()
        }
        outgoingRequestDetailsView.onOpenUser = { [weak self] in
            self?.output?.openUser()
        }
    }
}

// MARK: - OutgoingRequestDetailsViewInput

extension OutgoingRequestDetailsViewController: OutgoingRequestDetailsViewInput {

    func setupInitialState() {
        scrollView.alwaysBounceVertical = true
        hidesTabBar = true
        navigationBar.title = L10n.Localizable.RequestDetails.Outgoing.title
        navigationBar.rightItems = [moreButton]
    }

    func configure(with viewModel: OutgoingRequestDetailsView.ViewModel, moreActions: [UIAction]) {
        contentView.isHidden = false
        outgoingRequestDetailsView.configure(with: viewModel)
        moreButton.isHidden = moreActions.isEmpty
        moreButton.menu = .init(children: moreActions)
    }

}
