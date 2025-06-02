//
//  EditOfferViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 15/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveDataDisplayManager

final class EditOfferViewController: ScrollViewController {

    // MARK: - Constants

    private enum Constants {
        static let collectionItemsPerRow: CGFloat = 2
        static let collectionItemsSpacing: CGFloat = 8
        static let insets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let sectionInset: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
    }

    // MARK: - Properties

    var picturesCollectionView: UICollectionView {
        editOfferView.picturesCollectionView
    }

    var adapter: BaseCollectionManager?
    private typealias AddingImageCellGenerator = BaseCollectionCellGenerator<AddingImageCollectionViewCell>
    private typealias AddImageButtonCellGenerator = ContextMenuCollectionCellGenerator<AddImageButtonCollectionViewCell>
    private var addingImageGenerators: [AddingImageCellGenerator] = []
    private var addImageButtonCellGenerator: AddImageButtonCellGenerator {
        let generator = AddImageButtonCellGenerator(with: true, menu: addImageMenu)
        generator.didSelectEvent += { generator.triggerMenu() }
        return generator
    }
    private var isAddImageButtonShown = true

    private lazy var saveButton = {
        $0.title = L10n.Localizable.Offers.Edit.Button.save
        $0.insets = .zero
        $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        $0.setAction { [weak self] in
            self?.editOfferView.save()
        }
        return $0
    }(DButton(type: .plainPrimary))

    private lazy var editOfferView: EditOfferView = {
        $0.delegate = self
        return $0
    }(EditOfferView())

    private var picturesCollectionViewHeightConstraint: Constraint?

    private lazy var addImageMenu: UIMenu = .init(children: [
        UIAction(
            title: L10n.Localizable.Common.takeAPhoto, image: UIImage(systemName: "camera")
        ) { [weak self] _ in
            self?.output?.takeAPhoto()
        },
        UIAction(
            title: L10n.Localizable.Common.chooseFromLibrary, image: UIImage(systemName: "photo")
        ) { [weak self] _ in
            self?.output?.chooseFromLibrary()
        }
    ])

    var output: EditOfferViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
    }

    // MARK: - UI Setup

    private func setupUI() {
        contentView.addSubview(editOfferView)
        editOfferView.snp.makeConstraints { make in
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
            title: nil,
            image: UIImage(systemName: "xmark")?.withTintColor(.Domostroy.primary, renderingMode: .alwaysOriginal),
            action: { [weak self] in
                self?.output?.close()
            }
        )
    }

    // MARK: - Loadable

    override func setLoading(_ isLoading: Bool) {
        super.setLoading(isLoading)
        editOfferView.isHidden = isLoading
    }

}

// MARK: - EditOfferViewInput

extension EditOfferViewController: EditOfferViewInput {

    func setupInitialState() {
        setupUI()
        scrollView.keyboardDismissMode = .onDrag
        configurePicturesCollectionView()
        navigationBar.title = L10n.Localizable.Offers.Edit.title
        navigationBar.rightItems = [saveButton]
        hidesTabBar = true
        setupKeyboardObservers()
        addCloseButton()
    }

    func configure(with model: EditOfferViewModel) {
        editOfferView.nameTextField.setText(model.title)
        editOfferView.descriptionTextField.setText(model.description ?? "")
        editOfferView.priceTextField.setText(model.price)
        let isPriceNegotiable = model.price.isEmpty
        editOfferView.setIsPriceNegotiable(isPriceNegotiable)
        editOfferView.setPriceInput(visible: !isPriceNegotiable)
    }

    func setCategories(_ items: [String], placeholder: String, initialIndex: Int) {
        var categories = [placeholder]
        categories.append(contentsOf: items)
        editOfferView.categoryPicker.setItems(categories, selectedIndex: initialIndex + 1)
    }

    func setImages(_ images: [AddingImageCollectionViewCell.Model], canAddMore: Bool) {
        addingImageGenerators = images.map { makeImageGenerator(from: $0) }
        isAddImageButtonShown = canAddMore
        picturesCollectionViewHeightConstraint?.update(
            offset: calculatePicturesCollectionViewHeight(
                itemsAmount: images.count + (canAddMore ? 1 : 0)
            )
        )
        refillAdapter()
    }

    func setCity(title: String) {
        editOfferView.setCityButton(title: title)
    }

    func setPriceInput(visible: Bool) {
        editOfferView.setPriceInput(visible: visible)
    }

    func setSavingActivity(isLoading: Bool) {
        saveButton.setLoading(isLoading)
    }

    func setDeletingActivity(isLoading: Bool) {
        editOfferView.deleteButton.setLoading(isLoading)
    }

}

// MARK: - Adapter

private extension EditOfferViewController {

    private func makeImageGenerator(
        from model: AddingImageCollectionViewCell.Model
    ) -> AddingImageCellGenerator {
        let generator = AddingImageCollectionViewCell.rddm.baseGenerator(with: model, and: .class)
        return generator
    }

    func refillAdapter() {
        adapter?.clearCellGenerators()
        adapter?.addCellGenerators(addingImageGenerators)
        if isAddImageButtonShown {
            adapter?.addCellGenerator(addImageButtonCellGenerator)
        }
        adapter?.forceRefill()
    }
}
extension EditOfferViewController: EditOfferViewDelegate {
    func scrollToActiveView(_ view: UIView?) {
        guard let view else {
            return
        }
        scrollToView(view, offsetY: 40)
    }

    func scrollToInvalidView(_ view: UIView?) {
        guard let view else {
            return
        }
        scrollView.scrollRectToVisible(view.frame, animated: true)
    }

    func titleDidChange(_ title: String) {
        output?.titleChanged(title)
    }

    func descriptionDidChange(_ description: String) {
        output?.descriptionChanged(description)
    }

    func showCities() {
        output?.showCities()
    }

    func isPriceNegotiableDidChange(_ isNegotiable: Bool) {
        output?.isPriceNegotiableChanged(isNegotiable)
    }

    func saveOffer() {
        output?.save()
    }

    func deleteOffer() {
        output?.delete()
    }

    func didPickCategory(index: Int) {
        output?.setSelectedCategory(index: index)
    }

    func priceDidChange(_ price: String) {
        output?.priceChanged(price)
    }
}
