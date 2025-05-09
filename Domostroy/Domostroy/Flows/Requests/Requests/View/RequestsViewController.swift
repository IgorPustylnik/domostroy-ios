//
//  RequestsViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveDataDisplayManager

final class RequestsViewController: BaseViewController {

    // MARK: - Constants

    private enum Constants {
        static let progressViewHeight: CGFloat = 80
    }

    // MARK: - UI Elements

    private lazy var archiveButton = {
        $0.insets = .init(top: $0.insets.top, left: 0, bottom: $0.insets.bottom, right: 0)
        $0.setAction { [weak self] in
            self?.output?.openArchive()
        }
        $0.title = L10n.Localizable.Requests.Archive.title
        $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        return $0
    }(DButton(type: .plainPrimary))
    private lazy var segmentedControl = UISegmentedControl()

    private(set) lazy var refreshControl = UIRefreshControl()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private(set) lazy var progressView = PaginatorView()

    var adapter: BaseCollectionManager?

    // MARK: - Properties

    var output: RequestsViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        setupCollectionView()
        super.viewDidLoad()
        setupNavbar()
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
        observeScrollOffset(collectionView)
    }

    private func setupNavbar() {
        navigationBar.title = L10n.Localizable.Requests.title
        navigationBar.addArrangedSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(segmentedControlChangedIndex(_:)), for: .valueChanged)
        navigationBar.rightItems.append(archiveButton)
    }
}

// MARK: - RequestsViewInput

extension RequestsViewController: RequestsViewInput {
    func setupSegments(_ values: [String], selectedIndex: Int) {
        segmentedControl.removeAllSegments()
        for (index, value) in values.enumerated() {
            segmentedControl.insertSegment(withTitle: value, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = selectedIndex
    }
}

@objc
private extension RequestsViewController {
    func segmentedControlChangedIndex(_ sender: UISegmentedControl) {
        output?.selectRequestStatus(sender.selectedSegmentIndex)
    }
}
