//
//  OfferFilterViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 23/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit

final class OfferFilterViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let mainVStackSpacing: CGFloat = 10
        static let priceHStackSpacing: CGFloat = 10
        static let insets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
    }

    // MARK: - UI Elements

    private lazy var mainVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.mainVStackSpacing
        $0.addArrangedSubview(categoryLabel)
        $0.addArrangedSubview(categoryPicker)
        $0.addArrangedSubview(priceLabel)
        $0.addArrangedSubview(priceHStackView)
        return $0
    }(UIStackView())

    private lazy var categoryLabel = {
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.text = L10n.Localizable.Filter.Category.header
        return $0
    }(UILabel())

    private lazy var categoryPicker = {
        $0.onPick = { [weak self] picker in
            self?.output?.selectCategory(index: picker.selectedIndex)
        }
        return $0
    }(DPickerField())

    private lazy var priceLabel = {
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.text = L10n.Localizable.Filter.RentCost.header
        return $0
    }(UILabel())

    private lazy var priceHStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = Constants.priceHStackSpacing
        $0.addArrangedSubview(priceFromTextField)
        $0.addArrangedSubview(priceToTextField)
        return $0
    }(UIStackView())

    private lazy var priceFromTextField: DValidatableTextField = {
        $0.configure(
            placeholder: L10n.Localizable.Filter.RentCost.From.placeholder,
            correction: .no,
            keyboardType: .numberPad
        )
        $0.onTextChange = { [weak self] _ in
            guard let self else {
                return
            }
            self.output?.setPriceFrom(self.priceFromTextField.currentText())
        }
        $0.formatter = PrefixTextFieldFormatter(prefix: L10n.Localizable.Filter.RentCost.From.placeholder + " ")
        $0.validator = OptionalValidator(PriceValidator())
        $0.setUnit("₽/\(L10n.Plurals.day(1))")
        return $0
    }(DValidatableTextField())

    private lazy var priceToTextField: DValidatableTextField = {
        $0.configure(
            placeholder: L10n.Localizable.Filter.RentCost.To.placeholder,
            correction: .no,
            keyboardType: .numberPad
        )
        $0.onTextChange = { [weak self] _ in
            guard let self else {
                return
            }
            self.output?.setPriceTo(self.priceToTextField.currentText())
        }
        $0.formatter = PrefixTextFieldFormatter(prefix: L10n.Localizable.Filter.RentCost.To.placeholder + " ")
        $0.validator = OptionalValidator(PriceValidator())
        $0.setUnit("₽/\(L10n.Plurals.day(1))")
        return $0
    }(DValidatableTextField())

    private lazy var applyButton = {
        $0.title = L10n.Localizable.Filter.Button.apply
        $0.setAction { [weak self] in
            self?.output?.apply()
        }
        return $0
    }(DButton())

    // MARK: - Properties

    var output: OfferFilterViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSheetPresentation()
        output?.viewLoaded()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updatePreferredContentSize()
    }
}

// MARK: - Sheet presentation

private extension OfferFilterViewController {
    func setupSheetPresentation() {
        if let sheet = sheetPresentationController {
            sheet.detents = [
                .custom { _ in
                    return self.preferredContentSize.height
                }
            ]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
    }

    func updatePreferredContentSize() {
        let fittingSize = CGSize(width: view.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let fullHeight = view.systemLayoutSizeFitting(fittingSize,
                                                      withHorizontalFittingPriority: .required,
                                                      verticalFittingPriority: .fittingSizeLevel).height

        preferredContentSize = CGSize(width: view.bounds.width, height: fullHeight)
        sheetPresentationController?.animateChanges {}
    }
}

// MARK: - OfferFilterViewInput

extension OfferFilterViewController: OfferFilterViewInput {

    func setupInitialState() {
        title = L10n.Localizable.Filter.title
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .close, target: self, action: #selector(close))
        view.backgroundColor = .systemBackground
        view.addSubview(mainVStackView)
        view.addSubview(applyButton)
        mainVStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(Constants.insets)
            make.bottom.lessThanOrEqualTo(applyButton.snp.top).offset(-Constants.insets.bottom)
        }
        applyButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(Constants.insets)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-Constants.insets.bottom).priority(.medium)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.insets).priority(.low)
        }
    }

    func setCategories(_ items: [String], placeholder: String, initialIndex: Int) {
        var categories = [placeholder]
        categories.append(contentsOf: items)
        categoryPicker.setItems(categories, selectedIndex: initialIndex + 1)
    }

    func setPriceFilter(from: String, to: String) {
        priceFromTextField.setText(from)
        priceToTextField.setText(to)
    }

}

// MARK: - Selectors

@objc
private extension OfferFilterViewController {
    func close() {
        output?.dismiss()
    }
}
