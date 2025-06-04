//
//  OfferDetailsViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 10/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveDataDisplayManager

final class OfferDetailsViewController: ScrollViewController {

    // MARK: - Constants

    private enum Constants {
        static let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static let imageHorizontalItemSpace: CGFloat = 0
        static let pictureCollectionViewHeight: CGFloat = 300
        static let picturesPageControlBottomOffset: CGFloat = 8
        static let detailsInsets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
    }

    // MARK: - Properties

    private lazy var favoriteToggleButton = {
        $0.insets = .zero
        $0.onImage = .Buttons.favoriteFilled
        $0.offImage = .Buttons.favorite
        $0.isHidden = true
        return $0
    }(DToggleButton(type: .plainPrimary))

    private lazy var moreButton = {
        $0.image = .NavigationBar.moreOutline.withTintColor(.Domostroy.primary, renderingMode: .alwaysOriginal)
        $0.insets = .zero
        $0.showsMenuAsPrimaryAction = true
        $0.isHidden = true
        return $0
    }(DButton(type: .plainPrimary))

    private(set) var picturesCollectionView = UICollectionView(
        frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()
    )
    private lazy var picturesPageControl = {
        $0.isUserInteractionEnabled = false
        $0.hidesForSinglePage = true
        return $0
    }(UIPageControl())

    private(set) lazy var picturesCollectionDelegateProxy = CollectionScrollViewDelegateProxyPlugin()

    var picturesAdapter: BaseCollectionManager?
    private var pictureGenerators: [CollectionCellGenerator] = []

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
        contentView.addSubview(picturesPageControl)
        contentView.addSubview(offerDetailsView)

        picturesCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalTo(Constants.pictureCollectionViewHeight)
        }
        picturesPageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(picturesCollectionView.snp.bottom)
        }
        offerDetailsView.snp.makeConstraints { make in
            make.top.equalTo(picturesCollectionView.snp.bottom).offset(Constants.detailsInsets.top)
            make.bottom.equalToSuperview().inset(Constants.detailsInsets)
            make.horizontalEdges.equalToSuperview().inset(Constants.detailsInsets)
        }
        scrollView.alwaysBounceVertical = true
        navigationBar.rightItems = [favoriteToggleButton, moreButton]

        contentView.isHidden = true
    }

    private func configureCollectionView() {
        picturesCollectionView.backgroundColor = .secondarySystemBackground
        picturesCollectionView.showsHorizontalScrollIndicator = false
        picturesCollectionView.isPagingEnabled = true
        picturesCollectionView.alwaysBounceHorizontal = true
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

        picturesCollectionDelegateProxy.didEndDecelerating += { [weak self] scrollView in
            let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            self?.picturesPageControl.currentPage = index
        }
    }

}

// MARK: - OfferDetailsViewInput

extension OfferDetailsViewController: OfferDetailsViewInput {

    func setupInitialState() {
        offerDetailsView.setupInitialState()
    }

    func setupFavoriteToggle(initialState: Bool, toggleAction: ToggleClosure?) {
        favoriteToggleButton.setToggleAction(toggleAction)
        favoriteToggleButton.setOn(initialState)
        favoriteToggleButton.isHidden = false
    }

    func configureOffer(viewModel: OfferDetailsView.ViewModel) {
        contentView.isHidden = false
        offerDetailsView.configure(with: viewModel)
    }

    func configurePictures(with viewModels: [ImageCollectionViewCell.ViewModel]) {
        pictureGenerators = viewModels.enumerated().map { index, viewModel in
            let generator = ImageCollectionViewCell.rddm.baseGenerator(with: viewModel, and: .class)
            generator.didSelectEvent += { [weak self] in
                self?.output?.openFullScreenImages(initialIndex: index)
            }
            return generator
        }
        picturesPageControl.currentPage = 0
        picturesPageControl.numberOfPages = viewModels.count
        refillAdapter()
    }

    func scrollToImage(at index: Int) {
        guard index < pictureGenerators.count else {
            return
        }
        picturesCollectionView.scrollToItem(
            at: .init(row: index, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
        picturesPageControl.currentPage = index
    }

    func setupMoreActions(_ actions: [UIAction]) {
        moreButton.menu = .init(children: actions)
        moreButton.isHidden = actions.isEmpty
    }

}

// MARK: - Private methods

private extension OfferDetailsViewController {
    func refillAdapter() {
        picturesAdapter?.clearCellGenerators()
        picturesAdapter?.addCellGenerators(pictureGenerators)
        picturesAdapter?.forceRefill()
    }
}
