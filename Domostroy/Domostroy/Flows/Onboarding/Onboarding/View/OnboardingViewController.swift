//
//  OnboardingViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 31/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveDataDisplayManager

final class OnboardingViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let insets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let bottomVStackSpacing: CGFloat = 30
        static let pageDisplayDuration: TimeInterval = 10
    }

    // MARK: - Properties

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let collectionScrollDelegateProxy = CollectionScrollViewDelegateProxyPlugin()

    private lazy var bottomVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.bottomVStackSpacing
        $0.addArrangedSubview(pageControl)
        $0.addArrangedSubview(button)
        return $0
    }(UIStackView())

    private lazy var pageControl = {
        $0.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
        return $0
    }(UIPageControl())

    private lazy var button = {
        $0.setAction { [weak self] in
            self?.output?.next()
        }
        return $0
    }(DButton(type: .filledWhite))

    var adapter: BaseCollectionManager?

    typealias OnboardingPageCellGenerator = BaseCollectionCellGenerator<OnboardingPageCollectionViewCell>
    private var pagesGenerators: [OnboardingPageCellGenerator] = []

    var output: OnboardingViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
    }
}

// MARK: - OnboardingViewInput

extension OnboardingViewController: OnboardingViewInput {

    func setupInitialState() {
        view.backgroundColor = .Domostroy.primary

        view.addSubview(collectionView)
        view.addSubview(bottomVStackView)

        collectionView.snp.makeConstraints { make in
            make.bottom.equalTo(bottomVStackView.snp.top)
            make.top.horizontalEdges.equalToSuperview()
        }
        bottomVStackView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(Constants.insets)
        }

        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.alwaysBounceHorizontal = true
        view.layoutIfNeeded()

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = collectionView.bounds.size
        layout.sectionInset = .zero
        layout.minimumLineSpacing = .zero
        layout.minimumInteritemSpacing = .zero
        collectionView.setCollectionViewLayout(layout, animated: false)

        collectionScrollDelegateProxy.didEndDecelerating += { [weak self] scrollView in
            let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            self?.pageControl.currentPage = page
            self?.output?.setPage(index: page)
        }
    }

    func fillPages(with models: [OnboardingPageModel]) {
        pagesGenerators = models.map { .init(with: $0, registerType: .class) }
        refillAdapter()
        pageControl.numberOfPages = models.count
    }

    func setPage(index: Int, isLast: Bool) {
        guard index < pagesGenerators.count else {
            return
        }
        collectionView.isPagingEnabled = false
        collectionView.scrollToItem(at: .init(row: index, section: 0), at: .centeredHorizontally, animated: true)
        collectionView.isPagingEnabled = true
        pageControl.currentPage = index
        button.title = isLast ?
            OnboardingPresenterModel.Buttons.explore.title :
            OnboardingPresenterModel.Buttons.next.title
    }

}

// MARK: - Private methods

private extension OnboardingViewController {
    func refillAdapter() {
        adapter?.clearCellGenerators()
        adapter?.addCellGenerators(pagesGenerators)
        adapter?.forceRefill()
    }
}

// MARK: - Selectors

@objc
private extension OnboardingViewController {
    func pageControlDidChange(_ sender: UIPageControl) {
        output?.setPage(index: sender.currentPage)
    }
}
