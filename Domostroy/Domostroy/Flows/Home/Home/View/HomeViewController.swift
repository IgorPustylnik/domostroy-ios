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
        static let cellSpacing: CGFloat = 8
        static let cellHeight: CGFloat = 100
        static let progressViewHeight: CGFloat = 80
        static let boundaryItemSize: NSCollectionLayoutSize = {
            let estimatedHeight = TitleCollectionReusableView.getHeight(forWidth: UIScreen.main.bounds.width,
                                                                        with: "Some section")
            return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                   heightDimension: .estimated(estimatedHeight))
        }()
        static let sectionInsets: NSDirectionalEdgeInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
    }

    // MARK: - UI Elements

    private var activityIndicator = UIActivityIndicatorView(style: .medium)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    // MARK: - Private Properties

    lazy var progressView = PaginatorView()
    lazy var refreshControl = UIRefreshControl()

    var output: HomeViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        setupCollectionView()
        super.viewDidLoad()
        configureLayout()
        navigationBar.showsMainBar = false
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
        let header = makeSectionHeader()

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
        section.boundarySupplementaryItems = [header]

        return section
    }

    private func makeSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: Constants.boundaryItemSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
}

// MARK: - HomeViewInput

extension HomeViewController: HomeViewInput {

    func setupInitialState() {

    }

    func showLoader() {
        activityIndicator.isHidden = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }

    func hideLoader() {
        activityIndicator.stopAnimating()
    }

}
