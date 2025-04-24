//
//  UserProfileViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 24/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveDataDisplayManager

final class UserProfileViewController: BaseViewController {

    // MARK: - Constants

    private enum Constants {
        static let progressViewHeight: CGFloat = 80
        static let sectionInset: UIEdgeInsets = .init(top: 16, left: 0, bottom: 16, right: 0)
        static let contentInset: UIEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)
        static let animationDuration: Double = 0.3
    }

    // MARK: - UI Elements

    private var activityIndicator = UIActivityIndicatorView(style: .medium)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var adapter: BaseCollectionManager?

    typealias OfferCellGenerator = DiffableCalculatableHeightCollectionCellGenerator<OfferCollectionViewCell>
    typealias UserInfoCellGenerator = DiffableCalculatableHeightCollectionCellGenerator<UserProfileInfoCollectionViewCell>

    private var userGenerator: UserInfoCellGenerator?
    private var offerGenerators: [OfferCellGenerator] = []

    // MARK: - Private Properties

    private(set) lazy var progressView = PaginatorView()
    private(set) lazy var refreshControl = UIRefreshControl()

    var output: UserProfileViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        setupCollectionView()
        configureLayoutFlow()
        super.viewDidLoad()
        hidesTabBar = true
        output?.viewLoaded()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        progressView.frame = CGRect(
            x: 0,
            y: 0,
            width: collectionView.frame.width - Constants.contentInset.left - Constants.contentInset.right,
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

    private func configureLayoutFlow() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10.0
        flowLayout.minimumInteritemSpacing = 10.0
        flowLayout.sectionInset = Constants.sectionInset
        collectionView.contentInset = Constants.contentInset
        flowLayout.scrollDirection = .vertical

        collectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
}

// MARK: - UserProfileViewInput

extension UserProfileViewController: UserProfileViewInput {

    func setupInitialState() {

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

    func fillUser(with viewModel: UserProfileInfoCollectionViewCell.ViewModel) {
        userGenerator = UserInfoCellGenerator(
            uniqueId: UUID(),
            with: viewModel,
            width: calculateUserInfoCellWidth(),
            registerType: .class
        )
        refillAdapter()
    }

    func fillFirstPage(with viewModels: [OfferCollectionViewCell.ViewModel]) {
        offerGenerators = viewModels.map {
            let generator = OfferCellGenerator(
                uniqueId: UUID(),
                with: $0,
                width: calculateOfferCellWidth(),
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
                width: calculateOfferCellWidth(),
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

private extension UserProfileViewController {
    func calculateUserInfoCellWidth() -> CGFloat {
        guard let screenWidth = view.window?.screen.bounds.width else {
            return 0
        }
        return screenWidth - Constants.contentInset.left - Constants.contentInset.right
    }

    func calculateOfferCellWidth() -> CGFloat {
        guard let screenWidth = view.window?.screen.bounds.width else {
            return 0
        }
        return screenWidth - Constants.contentInset.left - Constants.contentInset.right
    }

    func refillAdapter() {
        adapter?.clearCellGenerators()
        adapter?.clearHeaderGenerators()
        adapter?.clearFooterGenerators()
        if let userGenerator {
            adapter?.addCellGenerator(userGenerator)
        }
        if offerGenerators.isEmpty {
            adapter?.addSectionHeaderGenerator(TitleCollectionHeaderGenerator(title: "No offers"))
        } else {
            adapter?.addCellGenerators(offerGenerators)
        }
        adapter?.forceRefill()
    }
}
