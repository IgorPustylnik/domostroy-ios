//
//  HomeViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveDataDisplayManager

final class HomeViewController: BaseViewController {

    // MARK: - Constants

    private enum Constants {
        static let progressViewHeight: CGFloat = 80
        static let sectionContentInset: NSDirectionalEdgeInsets = .init(top: 16, leading: 16, bottom: 0, trailing: 16)
        static let intergroupSpacing: CGFloat = 10
        static let interitemSpacing: CGFloat = 10
        static let animationDuration: Double = 0.3
    }

    // MARK: - UI Elements

    private lazy var searchTextField: DSearchTextField = {
        $0.onBeginEditing = { [weak self] _ in
            self?.output?.setSearch(active: true)
        }
        $0.onEndEditing = { [weak self] _ in
            self?.output?.setSearch(active: false)
        }
        $0.onShouldReturn = { [weak self] textField in
            self?.output?.setSearch(active: false)
            self?.output?.search(query: textField.text)
            textField.text = ""
        }
        $0.onCancel = { [weak self] textField in
            textField.text = ""
        }
        return $0
    }(DSearchTextField())

    private var activityIndicator = UIActivityIndicatorView(style: .medium)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var adapter: BaseCollectionManager?

    typealias OfferCellGenerator = DiffableCollectionCellGenerator<OfferCollectionViewCell>

    private var offerGenerators: [OfferCellGenerator] = []

    private lazy var emptyView = HomeEmptyView()

    private lazy var overlayView = UIView()

    // MARK: - Private Properties

    lazy var progressView = PaginatorView()
    lazy var refreshControl = UIRefreshControl()

    var output: HomeViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        setupCollectionView()
        setupSearchOverlayView()
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
        navigationBar.showsMainBar = false
        navigationBar.addArrangedSubview(searchTextField)
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

    private func setupSearchOverlayView() {
        view.addSubview(overlayView)
        overlayView.backgroundColor = .systemBackground
        overlayView.alpha = 0
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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

private extension HomeViewController {

    func makeLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.makeSectionLayout(for: sectionIndex)
        }

        return layout
    }

    func makeSectionLayout(for sectionIndex: Int) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
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

        let header = makeSectionHeader()
        section.boundarySupplementaryItems = [header]

        return section
    }

    func makeSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(1)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        return header
    }
}

// MARK: - HomeViewInput

extension HomeViewController: HomeViewInput {

    func setupInitialState() {

    }

    func setEmptyState(_ isEmpty: Bool) {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.emptyView.alpha = isEmpty ? 1 : 0
        }
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

    func setSearchOverlay(active: Bool) {
        UIView.animate(withDuration: Constants.animationDuration) {
            if active {
                self.overlayView.alpha = 1
            } else {
                self.overlayView.alpha = 0
            }
        }
    }

    func fillFirstPage(with viewModels: [OfferCollectionViewCell.ViewModel]) {
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

    func fillNextPage(with viewModels: [OfferCollectionViewCell.ViewModel]) {
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

private extension HomeViewController {
    func refillAdapter() {
        adapter?.clearCellGenerators()
        adapter?.clearHeaderGenerators()
        adapter?.clearFooterGenerators()
        if !offerGenerators.isEmpty {
            adapter?.addSectionHeaderGenerator(
                // TODO: Localize
                TitleCollectionHeaderGenerator(title: "Recommended")
            )
        }
        adapter?.addCellGenerators(offerGenerators)
        adapter?.forceRefill()
    }
}
