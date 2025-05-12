//
//  OutgoingRequestsViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 11/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveDataDisplayManager

final class OutgoingRequestsViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let progressViewHeight: CGFloat = 80
        static let sectionContentInset: NSDirectionalEdgeInsets = .init(top: 16, leading: 16, bottom: 0, trailing: 16)
        static let intergroupSpacing: CGFloat = 10
        static let interitemSpacing: CGFloat = 10
        static let animationDuration: Double = 0.3
    }

    // MARK: - UI Elements

    private(set) lazy var refreshControl = UIRefreshControl()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private(set) lazy var progressView = PaginatorView()

    private var activityIndicator = DLoadingIndicator()
    typealias OutgoingRequestCellGenerator = DiffableCollectionCellGenerator<OutgoingRequestCollectionViewCell>

    private var requestsGenerators: [CollectionCellGenerator] = []

    // TODO: Add custom empty view
    private lazy var emptyView = HomeEmptyView()

    var adapter: BaseCollectionManager?

    // MARK: - Properties

    var output: OutgoingRequestsViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupEmptyView()
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

    private func setupCollectionView() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { $0.center.equalToSuperview() }
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.alwaysBounceVertical = true
        collectionView.delaysContentTouches = false
        collectionView.setCollectionViewLayout(makeLayout(), animated: false)
    }

    private func setupEmptyView() {
        collectionView.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-Constants.progressViewHeight).priority(.high)
            make.centerX.equalToSuperview().priority(.high)
            make.horizontalEdges.equalToSuperview().priority(.high)
        }
        emptyView.alpha = 0
    }
}

// MARK: - OutgoingRequestsViewInput

extension OutgoingRequestsViewController: OutgoingRequestsViewInput {

    func setEmptyState(_ isEmpty: Bool) {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.emptyView.alpha = isEmpty ? 1 : 0
        }
    }

    func setLoading(_ isLoading: Bool) {
        if isLoading {
            setEmptyState(false)
            activityIndicator.isHidden = false
        } else {
            activityIndicator.isHidden = true
        }
    }

    func fillFirstPage(with viewModels: [OutgoingRequestCollectionViewCell.ViewModel]) {
        requestsGenerators = viewModels.map {
            let generator = OutgoingRequestCellGenerator(
                uniqueId: UUID(),
                with: $0,
                registerType: .class
            )
            generator.didSelectEvent += { [weak self, viewModel = $0] in
//                self?.output?.openOffer(viewModel.id)
            }
            return generator
        }
        refillAdapter()
    }

    func fillNextPage(with viewModels: [OutgoingRequestCollectionViewCell.ViewModel]) {
        let newGenerators = viewModels.map {
            let generator = OutgoingRequestCellGenerator(
                uniqueId: UUID(),
                with: $0,
                registerType: .class
            )
            generator.didSelectEvent += { [weak self, viewModel = $0] in
//                self?.output?.openOffer(viewModel.id)
            }
            return generator
        }
        requestsGenerators += newGenerators
        if let lastGenerator = adapter?.generators.last?.last {
            adapter?.insert(after: lastGenerator, new: newGenerators)
        } else {
            refillAdapter()
        }
    }
}

// MARK: - UICollectionViewCompositionalLayout

private extension OutgoingRequestsViewController {

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
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        group.interItemSpacing = .fixed(Constants.interitemSpacing)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = Constants.sectionContentInset
        section.interGroupSpacing = Constants.intergroupSpacing

        return section
    }
}

// MARK: - Private methods

private extension OutgoingRequestsViewController {
    func refillAdapter() {
        adapter?.clearCellGenerators()
        adapter?.clearHeaderGenerators()
        adapter?.clearFooterGenerators()
        adapter?.addCellGenerators(requestsGenerators)
        adapter?.forceRefill()
    }
}
