//
//  OfferDetailsViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 10/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit

final class OfferDetailsViewController: ScrollViewController {

    // MARK: - Constants

    private enum Constants {
        static let pictureSize = CGSize(width: 120, height: 120)
        static let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static let imageHorizontalItemSpace: CGFloat = 0
        static let pictureCollectionViewHeight: CGFloat = 300
        static let detailsInsets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
    }

    // MARK: - Properties

    var picturesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var offerDetailsView = OfferDetailsView()

    var output: OfferDetailsViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        setupUI()
        super.viewDidLoad()
        configureCollectionView()
        hidesTabBar = true
        output?.viewLoaded()
    }

    // MARK: - UI Setup

    private func setupUI() {
        contentView.addSubview(picturesCollectionView)
        contentView.addSubview(offerDetailsView)
        picturesCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalTo(Constants.pictureCollectionViewHeight)
        }
        offerDetailsView.snp.makeConstraints { make in
            make.top.equalTo(picturesCollectionView.snp.bottom).offset(Constants.detailsInsets.top)
            make.bottom.equalToSuperview().inset(Constants.detailsInsets)
            make.horizontalEdges.equalToSuperview().inset(Constants.detailsInsets)
        }
        scrollView.alwaysBounceVertical = true
    }

    private func configureCollectionView() {
        picturesCollectionView.showsHorizontalScrollIndicator = false
        picturesCollectionView.isPagingEnabled = true
        contentView.layoutIfNeeded()

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(
            width: picturesCollectionView.frame.width,
            height: Constants.pictureCollectionViewHeight
        )
        layout.sectionInset = Constants.sectionInset
        layout.minimumLineSpacing = Constants.imageHorizontalItemSpace
        layout.minimumInteritemSpacing = 0
        picturesCollectionView.setCollectionViewLayout(layout, animated: false)
    }

}

// MARK: - OfferDetailsViewInput

extension OfferDetailsViewController: OfferDetailsViewInput {

    func setupInitialState() {
        offerDetailsView.setupInitialState()
    }

    func setupFavoriteToggle(initialState: Bool, toggleAction: ToggleAction?) {
        navigationBar.addToggleToRight(
            initialState: initialState,
            onImage: .Buttons.favoriteFilled,
            offImage: .Buttons.favorite,
            toggleAction: toggleAction
        )
    }

    func configureOffer(viewModel: OfferDetailsView.ViewModel) {
        offerDetailsView.configure(with: viewModel)
    }

}
