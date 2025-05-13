//
//  SearchViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 11/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import ReactiveDataDisplayManager

final class SearchViewController: BaseViewController {

    // MARK: - Constants

    private enum Constants {
        static let progressViewHeight: CGFloat = 80
        static let sectionContentInset: NSDirectionalEdgeInsets = .init(top: 16, leading: 16, bottom: 0, trailing: 16)
        static let intergroupSpacing: CGFloat = 10
        static let interitemSpacing: CGFloat = 10
        static let searchHStackSpacing: CGFloat = 10
        static let searchSettingsViewHeight: CGFloat = 36
        static let animationDuration: Double = 0.3
    }

    // MARK: - UI Elements

    private lazy var searchHStackView = {
        $0.axis = .horizontal
        $0.spacing = Constants.searchHStackSpacing
        $0.addArrangedSubview(searchTextField)
        return $0
    }(UIStackView())

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
        }
        $0.onCancel = { [weak self] textField in
            self?.output?.cancelSearchFieldInput()
        }
        return $0
    }(DSearchTextField())

    private lazy var searchSettingsView = {
        $0.onOpenCity = { [weak self] in
            self?.output?.openCity()
        }
        $0.onOpenSort = { [weak self] in
            self?.output?.openSort()
        }
        $0.onOpenFilters = { [weak self] in
            self?.output?.openFilters()
        }
        return $0
    }(SearchSettingsView())

    private lazy var backButton = {
        $0.snp.makeConstraints { make in
            make.width.equalTo(24)
        }
        $0.insets = .zero
        $0.setAction { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        $0.image = .NavigationBar.chevronLeft.withTintColor(.Domostroy.primary, renderingMode: .alwaysOriginal)
        return $0
    }(DButton(type: .plainPrimary))

    private var activityIndicator = DLoadingIndicator()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var adapter: BaseCollectionManager?

    typealias OfferCellGenerator = DiffableCollectionCellGenerator<OfferCollectionViewCell>

    private var offerGenerators: [OfferCellGenerator] = []

    private var emptyView = SearchEmptyView()

    private lazy var overlayView = UIView()

    // MARK: - Private Properties

    lazy var progressView = PaginatorView()
    lazy var refreshControl = UIRefreshControl()

    var output: SearchViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        setupCollectionView()
        setupSearchOverlayView()
        setupEmptyView()
        super.viewDidLoad()
        setupNavigationBar()
        setupSearchSettingsView()
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
        navigationBar.addArrangedSubview(searchHStackView)
        addBackButtonIfNeeded()
    }

    private func addBackButtonIfNeeded() {
        if shouldShowBackButton {
            searchHStackView.insertArrangedSubview(backButton, at: 0)
        }
    }

    private func setupSearchSettingsView() {
        navigationBar.addArrangedSubview(searchSettingsView)
        searchSettingsView.snp.makeConstraints { make in
            make.height.equalTo(Constants.searchSettingsViewHeight)
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
            make.centerY.equalToSuperview()
                .offset(-Constants.progressViewHeight - Constants.searchSettingsViewHeight)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        emptyView.alpha = 0
    }
}

// MARK: - UICollectionViewCompositionalLayout

private extension SearchViewController {

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

// MARK: - SearchViewInput

extension SearchViewController: SearchViewInput {

    func setEmptyState(_ isEmpty: Bool) {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.emptyView.alpha = isEmpty ? 1 : 0
        }
    }

    func setQuery(_ query: String?) {
        searchTextField.setText(query)
    }

    func setCity(_ city: String?) {
        searchSettingsView.set(city: city)
    }

    func setSort(_ sort: String) {
        searchSettingsView.set(sort: sort)
    }

    func setHasFilters(_ hasFilters: Bool) {
        searchSettingsView.set(hasFilters: hasFilters)
    }

    func setLoading(_ isLoading: Bool) {
        if isLoading {
            setEmptyState(false)
            activityIndicator.isHidden = false
        } else {
            activityIndicator.isHidden = true
        }
    }

    func setSearchOverlay(active: Bool) {
        if active {
            searchSettingsView.removeFromSuperview()
        } else {
            self.navigationBar.addArrangedSubview(searchSettingsView)
        }
        navigationBar.setNeedsLayout()
        navigationBar.layoutIfNeeded()
        navigationBar.invalidateIntrinsicContentSize()
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

private extension SearchViewController {
    func refillAdapter() {
        adapter?.clearCellGenerators()
        adapter?.clearHeaderGenerators()
        adapter?.clearFooterGenerators()
        if !offerGenerators.isEmpty {
            adapter?.addSectionHeaderGenerator(EmptyCollectionHeaderGenerator())
        }
        adapter?.addCellGenerators(offerGenerators)
        adapter?.forceRefill()
    }
}
