//
//  SearchViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 11/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class SearchViewController: BaseViewController {

    // MARK: - Constants

    private enum Constants {
        static let cellSpacing: CGFloat = 8
        static let cellHeight: CGFloat = 100
        static let progressViewHeight: CGFloat = 80
        static let sectionInsets: NSDirectionalEdgeInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        static let searchHStackSpacing: CGFloat = 10
        static let searchSupplementaryViewHeight: CGFloat = 36
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
            textField.text = ""
        }
        $0.onCancel = { [weak self] textField in
            self?.output?.cancelSearchFieldInput()
        }
        return $0
    }(DSearchTextField())

    private lazy var searchSupplementaryView = {
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
    }(SearchSupplementaryView())

    private lazy var backButton = {
        $0.snp.makeConstraints { make in
            make.width.equalTo(24)
        }
        $0.setAction { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        $0.image = .NavigationBar.chevronLeft.withTintColor(.Domostroy.primary, renderingMode: .alwaysOriginal)
        return $0
    }(DButton(type: .plainPrimary))

    private var activityIndicator = UIActivityIndicatorView(style: .medium)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    private lazy var overlayView = UIView()

    // MARK: - Private Properties

    lazy var progressView = PaginatorView()
    lazy var refreshControl = UIRefreshControl()

    var output: SearchViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        setupCollectionView()
        setupSearchOverlayView()
        super.viewDidLoad()
        configureLayout()
        setupNavigationBar()
        setupSearchSupplementaryView()
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

    private func setupSearchSupplementaryView() {
        navigationBar.addArrangedSubview(searchSupplementaryView)
        searchSupplementaryView.snp.makeConstraints { make in
            make.height.equalTo(Constants.searchSupplementaryViewHeight)
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

    private func setupSearchOverlayView() {
        view.addSubview(overlayView)
        overlayView.backgroundColor = .systemBackground
        overlayView.alpha = 0
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
}

// MARK: - SearchViewInput

extension SearchViewController: SearchViewInput {

    func set(query: String?) {
        searchTextField.setText(query)
    }

    func set(city: String?) {
        searchSupplementaryView.set(city: city)
    }

    func set(sort: String) {
        searchSupplementaryView.set(sort: sort)
    }

    func set(hasFilters: Bool) {
        searchSupplementaryView.set(hasFilters: hasFilters)
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

    func setSearchOverlay(active: Bool) {
        if active {
            searchSupplementaryView.removeFromSuperview()
        } else {
            self.navigationBar.addArrangedSubview(searchSupplementaryView)
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

}
