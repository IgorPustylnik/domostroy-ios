//
//  FullScreenImagesViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 01/06/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveDataDisplayManager

final class FullScreenImagesViewController: UIViewController {

    // MARK: - Properties

    private var isNavigationBarVisible = true

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    var adapter: BaseCollectionManager?
    let scrollDelegateProxy = CollectionScrollViewDelegateProxyPlugin()

    typealias FullScreenImageCellGenerator = BaseCollectionCellGenerator<FullScreenImageCollectionViewCell>
    private var generators: [FullScreenImageCellGenerator] = []

    var output: FullScreenImagesViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = collectionView.bounds.size
        }
    }

    // MARK: - UI Setup

    private func configureCollectionView() {
        collectionView.backgroundColor = .black
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero

        collectionView.setCollectionViewLayout(layout, animated: false)

        scrollDelegateProxy.didEndDecelerating += { [weak self] scrollView in
            let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            self?.output?.scrolledTo(index: page)
        }

        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(
                toggleNavigationBarVisibility
            )
        )
        collectionView.addGestureRecognizer(tapGestureRecognizer)
    }

    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = .init(
            image: UIImage(systemName: "xmark")?.withTintColor(
                .Domostroy.primary,
                renderingMode: .alwaysOriginal
            ),
            style: .plain,
            target: self,
            action: #selector(close)
        )

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black.withAlphaComponent(0.5)

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
    }

    private func setupDismissSwipeGesture() {
        isModalInPresentation = false
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(close))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
}

// MARK: - FullScreenImagesViewInput

extension FullScreenImagesViewController: FullScreenImagesViewInput {
    func setupInitialState() {
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        setupNavigationBar()
        configureCollectionView()
        setupDismissSwipeGesture()
    }

    func setup(with images: [FullScreenImageCollectionViewCell.ViewModel], initialIndex: Int) {
        generators = images.map { .init(with: $0, registerType: .class) }
        refillAdapter { [weak self] in
            guard let self, initialIndex < generators.count else {
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                self.collectionView.scrollToItem(
                    at: .init(row: initialIndex, section: 0),
                    at: .centeredHorizontally,
                    animated: false
                )
            }
        }
    }

    func setNavigationTitle(_ title: String?) {
        self.title = title
    }
}

// MARK: - Private methods

private extension FullScreenImagesViewController {
    func refillAdapter(completion: EmptyClosure?) {
        adapter?.clearCellGenerators()
        adapter?.addCellGenerators(generators)
        adapter?.forceRefill { completion?() }
    }
}

// MARK: - Selectors

@objc
private extension FullScreenImagesViewController {
    func close() {
        output?.dismiss()
    }

    func toggleNavigationBarVisibility() {
        isNavigationBarVisible.toggle()
        UIView.animate(withDuration: 0.3) {
            self.navigationController?.navigationBar.alpha = self.isNavigationBarVisible ? 1 : 0
        }
    }
}
