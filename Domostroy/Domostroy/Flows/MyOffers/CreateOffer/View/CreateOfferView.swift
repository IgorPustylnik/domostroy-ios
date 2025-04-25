//
//  CreateOfferView.swift
//  Domostroy
//
//  Created by igorpustylnik on 15/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

final class CreateOfferView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let insets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let mainVStackSpacing: CGFloat = 16
    }

    // MARK: - UI Elements

    private lazy var mainVStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.mainVStackSpacing
        [
            nameLabel,
            nameTextField,
            descriptionLabel,
            descriptionTextField,
            categoryLabel,
            categoryPicker,
            conditionLabel,
            conditionPicker,
            picturesLabel,
            picturesCollectionView,
            calendarLabel,
            calendarButton,
            priceLabel,
            priceTextField,
            publishButton
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    // TODO: Localize
    private lazy var nameLabel = createHeaderLabel("Name")

    private lazy var nameTextField: DValidatableTextField = {
        // TODO: Localize
        $0.configure(placeholder: "Name", correction: .no, keyboardType: .default)
        $0.validator = RequiredValidator(OfferNameValidator())
        $0.setNextResponder(descriptionTextField.responder)
        $0.onBeginEditing = { [weak self] _ in
            self?.onScrollToActiveView?(self?.nameTextField)
        }
        return $0
    }(DValidatableTextField())

    // TODO: Localize
    private lazy var descriptionLabel = createHeaderLabel("Description")

    private lazy var descriptionTextField: DValidatableMultilineTextField = {
        // TODO: Localize
        $0.configure(placeholder: "Description", correction: .no, keyboardType: .default)
        $0.validator = OptionalValidator(OfferDescriptionValidator())
        $0.onBeginEditing = { [weak self] _ in
            self?.onScrollToActiveView?(self?.descriptionTextField)
        }
        return $0
    }(DValidatableMultilineTextField())

    // TODO: Localize
    private lazy var categoryLabel = createHeaderLabel("Category")

    // TODO: Chooser
    lazy var categoryPicker = {
        $0.requiresNonPlaceholder = true
        return $0
    }(DPickerField())

    // TODO: Localize
    private lazy var conditionLabel = createHeaderLabel("Condition")

    // TODO: Chooser
    lazy var conditionPicker = {
        $0.requiresNonPlaceholder = true
        return $0
    }(DPickerField())

    // TODO: Localize
    private lazy var picturesLabel = createHeaderLabel("Pictures")

    let picturesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    // TODO: Localize
    private lazy var calendarLabel = createHeaderLabel("Available dates")

    private lazy var calendarButton = {
        // TODO: Localize
        $0.title = "Available dates"
        $0.image = .Buttons.calendar.withTintColor(.label, renderingMode: .alwaysOriginal)
        $0.imagePlacement = .right
        $0.setAction { [weak self] in
            self?.onShowCalendar?()
        }
        return $0
    }(DButton(type: .calendar))

    // TODO: Localize
    private lazy var priceLabel = createHeaderLabel("Price")

    private lazy var priceTextField: DValidatableTextField = {
        $0.configure(placeholder: "Price", correction: .no, keyboardType: .numberPad)
        $0.validator = RequiredValidator(PriceValidator())
        $0.onBeginEditing = { [weak self] _ in
            self?.onScrollToActiveView?(self?.priceTextField)
        }
        $0.setUnit("₽/day")
        return $0
    }(DValidatableTextField())

    private lazy var publishButton = {
        // TODO: Localize
        $0.title = "Publish"
        $0.setAction { [weak self] in
            self?.publish()
        }
        return $0
    }(DButton())

    // MARK: - Properties

    var onPublish: EmptyClosure?
    var onScrollToActiveView: ((UIView?) -> Void)?
    var onShowCalendar: EmptyClosure?

    var title: String {
        nameTextField.currentText()
    }
    var itemDescription: String {
        descriptionTextField.currentText()
    }
    var category: String {
        categoryPicker.currentText()
    }
    var condition: String {
        conditionPicker.currentText()
    }
    var price: Double {
        do {
            return try Double(priceTextField.currentText(), format: .number)
        } catch {
            return 0
        }
    }

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - UI Setup

    private func setupUI() {
        addSubview(mainVStackView)
        mainVStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.insets)
        }
    }

}

// MARK: - Private methods

private extension CreateOfferView {
    func createHeaderLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.text = text
        return label
    }
}

private extension CreateOfferView {
    func publish() {
        endEditing(true)
        let textFields = mainVStackView.arrangedSubviews.compactMap { $0 as? DValidatableTextField }
        let multilineTextFields = mainVStackView.arrangedSubviews.compactMap { $0 as? DValidatableMultilineTextField }
        let pickers = mainVStackView.arrangedSubviews.compactMap { $0 as? DPickerField }
        if textFields.allSatisfy({ $0.isValid() }),
           multilineTextFields.allSatisfy({ $0.isValid() }),
           pickers.allSatisfy({ $0.isValid() }) {
            onPublish?()
            return
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
        textFields.forEach { $0.isValid() }
        multilineTextFields.forEach { $0.isValid() }
        pickers.forEach { $0.isValid() }
    }
}
