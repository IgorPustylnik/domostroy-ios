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
        configureLayoutFlow()
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

    func configureLayoutFlow() {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - Constants.cellSpacing * 2
        layout.itemSize = .init(width: width, height: Constants.cellHeight)
        collectionView.setCollectionViewLayout(layout, animated: false)
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
