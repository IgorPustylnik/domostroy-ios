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
        static let sectionContentInset: NSDirectionalEdgeInsets = .init(top: 16, leading: 16, bottom: 0, trailing: 16)
        static let intergroupSpacing: CGFloat = 10
        static let interitemSpacing: CGFloat = 10
        static let animationDuration: Double = 0.3
    }

    // MARK: - UI Elements

    private var activityIndicator = DLoadingIndicator()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var adapter: BaseCollectionManager?

    typealias OfferCellGenerator = DiffableCollectionCellGenerator<OfferCollectionViewCell>
    typealias UserInfoCellGenerator = DiffableCollectionCellGenerator<UserProfileInfoCollectionViewCell>

    private var userGenerator: UserInfoCellGenerator = .init(
        uniqueId: UUID(),
        with: .init(
            imageUrl: nil, loadImage: nil, username: nil, info1: nil, info2: nil, info3: nil
        ),
        registerType: .class
    )
    private var offerGenerators: [OfferCellGenerator] = []
    private var offersHeader: String = ""

    // MARK: - Private Properties

    private(set) lazy var progressView = PaginatorView()
    private(set) lazy var refreshControl = UIRefreshControl()

    var output: UserProfileViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        setupCollectionView()
        super.viewDidLoad()
        hidesTabBar = true
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
        collectionView.setCollectionViewLayout(makeLayout(), animated: false)
        observeScrollOffset(collectionView)
    }
}

// MARK: - UICollectionViewCompositionalLayout

private extension UserProfileViewController {

    func makeLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self else {
                return nil
            }
            switch sectionIndex {
            case 0:
                return self.makeUserInfoSectionLayout(for: sectionIndex)
            case 1:
                return self.makeOfferSectionLayout(for: sectionIndex)
            default:
                return self.makeOfferSectionLayout(for: sectionIndex)
            }
        }

        return layout
    }

    func makeOfferSectionLayout(for sectionIndex: Int) -> NSCollectionLayoutSection {
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

    func makeSectionFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
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

    func makeUserInfoSectionLayout(for sectionIndex: Int) -> NSCollectionLayoutSection {
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

// MARK: - UserProfileViewInput

extension UserProfileViewController: UserProfileViewInput {

    func setupInitialState() {

    }

    func setLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.isHidden = false
        } else {
            activityIndicator.isHidden = true
        }
    }

    func fillUser(with viewModel: UserProfileInfoCollectionViewCell.ViewModel, isBanned: Bool) {
        userGenerator = UserInfoCellGenerator(
            uniqueId: UUID(),
            with: viewModel,
            registerType: .class
        )
        offersHeader = isBanned ? L10n.Localizable.UserProfile.isBanned : ""
        refillAdapter()
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

    func setupMoreActions(_ actions: [UIAction]) {
        let moreButton = DButton(type: .plainPrimary)
        moreButton.image = .NavigationBar.moreOutline.withTintColor(.Domostroy.primary, renderingMode: .alwaysOriginal)
        moreButton.insets = .zero
        moreButton.menu = .init(children: actions)
        moreButton.showsMenuAsPrimaryAction = true
        navigationBar.rightItems = actions.isEmpty ? [] : [moreButton]
    }

}

// MARK: - Private methods

private extension UserProfileViewController {
    func refillAdapter() {
        adapter?.clearCellGenerators()
        adapter?.clearHeaderGenerators()
        adapter?.clearFooterGenerators()

        adapter?.addSectionHeaderGenerator(EmptyCollectionHeaderGenerator())
        adapter?.addCellGenerator(userGenerator)

        if offerGenerators.isEmpty {
            adapter?.addSectionHeaderGenerator(
                TitleCollectionHeaderGenerator(
                    title: offersHeader.isEmpty ? L10n.Localizable.UserProfile.Section.Offers.empty : offersHeader
                )
            )
        } else {
            adapter?.addSectionHeaderGenerator(
                TitleCollectionHeaderGenerator(title: offersHeader)
            )
            adapter?.addCellGenerators(offerGenerators)
        }

        adapter?.forceRefill()
    }
}
