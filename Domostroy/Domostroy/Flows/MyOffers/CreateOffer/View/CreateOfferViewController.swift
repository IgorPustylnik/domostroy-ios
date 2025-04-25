//
//  CreateOfferViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 15/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit

final class CreateOfferViewController: ScrollViewController {

    // MARK: - Constants

    private enum Constants {
        static let collectionItemsPerRow: CGFloat = 2
        static let collectionItemsSpacing: CGFloat = 8
        static let insets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let sectionInset: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
    }

    // MARK: - Properties

    var picturesCollectionView: UICollectionView {
        createOfferView.picturesCollectionView
    }
    private lazy var createOfferView: CreateOfferView = {
        $0.onScrollToActiveView = { [weak self] view in
            guard let self, let view else {
                return
            }
            self.scrollToView(view, offsetY: 40)
        }
        $0.onShowCalendar = { [weak self] in
            self?.output?.showCalendar()
        }
        $0.onPublish = { [weak self] in
            guard let self else {
                return
            }
            self.output?.create(
                details: .init(
                    title: self.createOfferView.title,
                    description: self.createOfferView.itemDescription,
                    category: self.createOfferView.category,
                    condition: self.createOfferView.condition,
                    price: self.createOfferView.price
                )
            )
        }
        return $0
    }(CreateOfferView())

    private var picturesCollectionViewHeightConstraint: Constraint?

    var output: CreateOfferViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        setupUI()
        super.viewDidLoad()
        scrollView.keyboardDismissMode = .onDrag
        configurePicturesCollectionView()
        // TODO: Localize
        navigationBar.title = "New offer"
        hidesTabBar = true
        setupKeyboardObservers()
        addCloseButton()
        output?.viewLoaded()
    }

    // MARK: - UI Setup

    private func setupUI() {
        contentView.addSubview(createOfferView)
        createOfferView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        picturesCollectionView.snp.makeConstraints { make in
            picturesCollectionViewHeightConstraint = make.height
                .equalTo(calculatePicturesCollectionViewHeight(itemsAmount: 1)).constraint
        }
        scrollView.alwaysBounceVertical = true
    }

    private func configurePicturesCollectionView() {
        picturesCollectionView.showsHorizontalScrollIndicator = false

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = Constants.sectionInset
        layout.minimumLineSpacing = Constants.collectionItemsSpacing
        layout.minimumInteritemSpacing = 0

        contentView.layoutIfNeeded()
        let collectionHeight = picturesCollectionView.frame.height
        let totalSpacing = Constants.collectionItemsSpacing
        let itemWidth = (
            picturesCollectionView.frame.width - totalSpacing
        ) / Constants.collectionItemsPerRow
        let size = min(itemWidth, collectionHeight)

        layout.itemSize = CGSize(width: size, height: size)
        picturesCollectionView.setCollectionViewLayout(layout, animated: false)
    }

    private func calculatePicturesCollectionViewHeight(itemsAmount: Int) -> CGFloat {
        guard itemsAmount > 0 else {
            return 0
        }

        let itemsPerRow = Constants.collectionItemsPerRow
        let totalHorizontalInsets = Constants.collectionItemsSpacing + Constants.insets.left + Constants.insets.right
        let itemWidth = (view.frame.width - totalHorizontalInsets) / Constants.collectionItemsPerRow

        let rows = Int(ceil(Double(itemsAmount) / itemsPerRow))
        let totalHeight = CGFloat(rows) * itemWidth + CGFloat(rows - 1) * Constants.collectionItemsSpacing

        return totalHeight
    }

    private func addCloseButton() {
        navigationBar.addButtonToLeft(
            image: UIImage(systemName: "xmark")?.withTintColor(.Domostroy.primary, renderingMode: .alwaysOriginal),
            action: { [weak self] in
                self?.output?.close()
            }
        )
    }

}

extension CreateOfferViewController: CreateOfferViewInput {

    func setupInitialState() {

    }

    func setCategories(_ items: [String]) {
        // TODO: Localize
        var categories = ["Categories"]
        categories.append(contentsOf: items)
        createOfferView.categoryPicker.setItems(categories)
    }

    func setConditions(_ items: [String]) {
        // TODO: Localize
        var conditions = ["Condition"]
        conditions.append(contentsOf: items)
        createOfferView.conditionPicker.setItems(conditions)
    }

    func updateImagesAmount(_ amount: Int) {
        picturesCollectionViewHeightConstraint?.update(
            offset: calculatePicturesCollectionViewHeight(
                itemsAmount: amount
            )
        )
    }

}
