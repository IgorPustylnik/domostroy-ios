//
//  FavoritesViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class FavoritesViewController: BaseViewController {

    // MARK: - Constants

    private enum Constants {
        static let progressViewHeight: CGFloat = 80
        static let sectionContentInset: NSDirectionalEdgeInsets = .init(top: 16, leading: 16, bottom: 0, trailing: 16)
        static let intergroupSpacing: CGFloat = 10
        static let interitemSpacing: CGFloat = 10
        static let settingsViewHeight: CGFloat = 36
        static let animationDuration: Double = 0.3
    }

    // MARK: - UI Elements

    private lazy var settingsView = {
        $0.onOpenSort = { [weak self] in
            self?.output?.openSort()
        }
        return $0
    }(FavoritesSettingsView())

    private var activityIndicator = UIActivityIndicatorView(style: .medium)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var adapter: BaseCollectionManager?

    typealias OfferCellGenerator = DiffableCollectionCellGenerator<FavoriteOfferCollectionViewCell>

    private var offerGenerators: [OfferCellGenerator] = []

    private var emptyView = FavoritesEmptyView()

    // MARK: - Private Properties

    lazy var progressView = PaginatorView()
    lazy var refreshControl = UIRefreshControl()

    var output: FavoritesViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        output?.viewLoaded()
        super.viewDidLoad()
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
        navigationBar.title = L10n.Localizable.Offers.Favorites.title
        settingsView.snp.makeConstraints { make in
            make.height.equalTo(Constants.settingsViewHeight)
        }
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
            make.centerY.equalToSuperview()
                .offset(-Constants.progressViewHeight - Constants.settingsViewHeight)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        emptyView.alpha = 0
    }
}

// MARK: - UICollectionViewCompositionalLayout

private extension FavoritesViewController {

    func makeLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
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
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        group.interItemSpacing = .fixed(Constants.interitemSpacing)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = Constants.sectionContentInset
        section.interGroupSpacing = Constants.intergroupSpacing

        return section
    }
}

// MARK: - FavoritesViewInput

extension FavoritesViewController: FavoritesViewInput {

    func setupInitialState() {
        setupCollectionView()
        setupEmptyView()
        setupNavigationBar()
    }

    func setEmptyState(_ isEmpty: Bool) {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.emptyView.alpha = isEmpty ? 1 : 0
        }
    }

    func setSort(_ sort: String?) {
        if let sort {
            settingsView.set(sort: sort)
            navigationBar.addArrangedSubview(settingsView)
        } else {
            settingsView.removeFromSuperview()
        }
        navigationBar.setNeedsLayout()
        navigationBar.layoutIfNeeded()
        navigationBar.invalidateIntrinsicContentSize()
    }

    func setLoading(_ isLoading: Bool) {
        if isLoading {
            setEmptyState(false)
            activityIndicator.isHidden = false
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    func fillFirstPage(with viewModels: [FavoriteOfferCollectionViewCell.ViewModel]) {
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

    func fillNextPage(with viewModels: [FavoriteOfferCollectionViewCell.ViewModel]) {
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

private extension FavoritesViewController {
    func refillAdapter() {
        adapter?.clearCellGenerators()
        adapter?.clearHeaderGenerators()
        adapter?.clearFooterGenerators()
        adapter?.addCellGenerators(offerGenerators)
        adapter?.forceRefill()
    }
}
