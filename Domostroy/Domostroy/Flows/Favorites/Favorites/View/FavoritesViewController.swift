//
//  FavoritesViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class FavoritesViewController: BaseViewController {

    // MARK: - Constants

    private enum Constants {
        static let cellSpacing: CGFloat = 8
        static let cellHeight: CGFloat = 100
        static let progressViewHeight: CGFloat = 80
        static let sectionInsets: NSDirectionalEdgeInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
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
        navigationBar.title = "Favorites"
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
    }

    private func configureLayout() {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            switch sectionIndex {
            case 0:
                return self?.createOffersSection()
            default:
                return self?.createOffersSection()
            }
        }
        collectionView.setCollectionViewLayout(layout, animated: false)
    }

    private func createOffersSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(Constants.cellHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(Constants.cellHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = Constants.sectionInsets
        section.interGroupSpacing = Constants.cellSpacing

        return section
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

// MARK: - FavoritesViewInput

extension FavoritesViewController: FavoritesViewInput {

    func setupInitialState() {
        setupCollectionView()
        setupEmptyView()
        configureLayout()
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
            activityIndicator.isHidden = false
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

}
