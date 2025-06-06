//
//  MyOffersViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class MyOffersViewController: BaseViewController {

    // MARK: - Constants

    private enum Constants {
        static let progressViewHeight: CGFloat = 80
        static let sectionContentInset: NSDirectionalEdgeInsets = .init(top: 16, leading: 16, bottom: 0, trailing: 16)
        static let intergroupSpacing: CGFloat = 10
        static let interitemSpacing: CGFloat = 10
        static let animationDuration: Double = 0.3
    }

    // MARK: - Properties

    var output: MyOffersViewOutput?

    // MARK: - UI Elements

    private var activityIndicator = DLoadingIndicator()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    var adapter: BaseCollectionManager?

    typealias OfferCellGenerator = DiffableCollectionCellGenerator<OwnOfferCollectionViewCell>

    private var offerGenerators: [OfferCellGenerator] = []

    private var emptyView = MyOffersEmptyView()

    lazy var progressView = PaginatorView()
    lazy var refreshControl = UIRefreshControl()

    // MARK: - UIViewController

    override func viewDidLoad() {
        setupCollectionView()
        setupEmptyView()
        super.viewDidLoad()
        setupNavigationBar()
        output?.viewLoaded()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        progressView.frame = CGRect(
            x: 0,
            y: 0,
            width: collectionView.frame.width,
            height: Constants.progressViewHeight
        )
    }

    private func setupNavigationBar() {
        navigationBar.title = L10n.Localizable.Offers.MyOffers.title
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { $0.center.equalToSuperview() }
        collectionView.alwaysBounceVertical = true
        observeScrollOffset(collectionView)
        collectionView.setCollectionViewLayout(makeLayout(), animated: false)
    }

    private func setupEmptyView() {
        collectionView.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-Constants.progressViewHeight)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        emptyView.alpha = 0
    }
}

// MARK: - UICollectionViewCompositionalLayout

private extension MyOffersViewController {

    func makeLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self else {
                return nil
            }
            return self.makeSectionLayout(for: sectionIndex)
        }

        return layout
    }

    func makeSectionLayout(for sectionIndex: Int) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(Constants.interitemSpacing)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = Constants.sectionContentInset
        section.interGroupSpacing = Constants.intergroupSpacing

        return section
    }
}

// MARK: - MyOffersViewInput

extension MyOffersViewController: MyOffersViewInput {

    func setupInitialState() {

    }

    func setLoading(_ isLoading: Bool) {
        if isLoading {
            setEmptyState(false)
            activityIndicator.isHidden = false
        } else {
            activityIndicator.isHidden = true
        }
    }

    func setEmptyState(_ isEmpty: Bool) {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.emptyView.alpha = isEmpty ? 1 : 0
        }
    }

    func fillFirstPage(with viewModels: [OwnOfferCollectionViewCell.ViewModel]) {
        offerGenerators = viewModels.map {
            let generator = OfferCellGenerator(
                uniqueId: UUID(),
                with: $0,
                registerType: .class
            )
            generator.didSelectEvent += { [weak self, viewModel = $0] in
                self?.output?.openOffer(viewModel.id)
            }
            return generator
        }
        refillAdapter()
    }

    func fillNextPage(with viewModels: [OwnOfferCollectionViewCell.ViewModel]) {
        let newGenerators = viewModels.map {
            let generator = OfferCellGenerator(
                uniqueId: UUID(),
                with: $0,
                registerType: .class
            )
            generator.didSelectEvent += { [weak self, viewModel = $0] in
                self?.output?.openOffer(viewModel.id)
            }
            return generator
        }
        offerGenerators += newGenerators
        if let lastGenerator = adapter?.generators.last?.last {
            adapter?.insert(after: lastGenerator, new: newGenerators)
        } else {
            refillAdapter()
        }
    }

}

// MARK: - Private methods

private extension MyOffersViewController {
    func refillAdapter() {
        adapter?.clearCellGenerators()
        adapter?.clearHeaderGenerators()
        adapter?.clearFooterGenerators()
        adapter?.addCellGenerators(offerGenerators)
        adapter?.forceRefill()
    }
}
