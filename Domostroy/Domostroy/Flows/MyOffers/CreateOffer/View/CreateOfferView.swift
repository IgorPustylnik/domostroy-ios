//
//  CreateOfferView.swift
//  Domostroy
//
//  Created by igorpustylnik on 15/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit

// MARK: - CreateOfferViewDelegate

protocol CreateOfferViewDelegate: AnyObject {
    func scrollToActiveView(_ view: UIView?)
    func scrollToInvalidView(_ view: UIView?)
    func titleDidChange(_ title: String)
    func descriptionDidChange(_ description: String)
    func showCities()
    func showCalendar()
    func publishOffer()
    func didPickCategory(index: Int)
    func isPriceNegotiableDidChange(_ isNegotiable: Bool)
    func priceDidChange(_ price: String)
}

// MARK: - CreateOfferView

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
            picturesLabel,
            picturesCollectionView,
            cityLabel,
            cityButton,
            calendarLabel,
            calendarButton,
            priceLabel,
            negitableCheckmark,
            priceTextField,
            publishButton
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    // MARK: Name

    private lazy var nameLabel = createHeaderLabel(L10n.Localizable.Offers.Create.Label.name)

    private lazy var nameTextField: DValidatableTextField = {
        $0.configure(
            placeholder: L10n.Localizable.Offers.Create.Placeholder.name, correction: .no, keyboardType: .default
        )
        $0.validator = RequiredValidator(OfferNameValidator())
        $0.setNextResponder(descriptionTextField.responder)
        $0.onBeginEditing = { [weak self] _ in
            self?.delegate?.scrollToActiveView(self?.nameTextField)
        }
        $0.onTextChange = { [weak self] _ in
            guard let self else {
                return
            }
            self.delegate?.titleDidChange(self.nameTextField.currentText())
        }
        return $0
    }(DValidatableTextField())

    // MARK: Description

    private lazy var descriptionLabel = createHeaderLabel(L10n.Localizable.Offers.Create.Label.description)

    private lazy var descriptionTextField: DValidatableMultilineTextField = {
        $0.configure(
            placeholder: L10n.Localizable.Offers.Create.Placeholder.description,
            correction: .no,
            keyboardType: .default,
            autocapitalizationType: .sentences
        )
        $0.validator = OptionalValidator(OfferDescriptionValidator())
        $0.onBeginEditing = { [weak self] _ in
            self?.delegate?.scrollToActiveView(self?.descriptionTextField)
        }
        $0.onTextChange = { [weak self] _ in
            guard let self else {
                return
            }
            self.delegate?.descriptionDidChange(self.descriptionTextField.currentText())
        }
        return $0
    }(DValidatableMultilineTextField())

    // MARK: Category

    private lazy var categoryLabel = createHeaderLabel(L10n.Localizable.Offers.Create.Label.category)

    private(set) lazy var categoryPicker = {
        $0.requiresNonPlaceholder = true
        $0.onPick = { [weak self] pickerField in
            self?.delegate?.didPickCategory(index: pickerField.selectedIndex)
        }
        return $0
    }(DPickerField())

    // MARK: Pictures

    private lazy var picturesLabel = createHeaderLabel(L10n.Localizable.Offers.Create.Label.pictures)

    let picturesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    // MARK: City

    private lazy var cityLabel = createHeaderLabel(L10n.Localizable.Offers.Create.Label.city)

    private lazy var cityButton = {
        $0.title = L10n.Localizable.Offers.Create.Button.City.placeholder
        $0.image = .Buttons.locationFilled.withTintColor(.label, renderingMode: .alwaysOriginal)
        $0.imagePlacement = .right
        $0.setAction { [weak self] in
            self?.delegate?.showCities()
        }
        return $0
    }(DButton(type: .modalPicker))

    // MARK: Calendar

    private lazy var calendarLabel = createHeaderLabel(L10n.Localizable.Offers.Create.Label.availableDates)

    private lazy var calendarButton = {
        $0.title = L10n.Localizable.Offers.Create.Button.AvailableDates.placeholder
        $0.image = .Buttons.calendar.withTintColor(.label, renderingMode: .alwaysOriginal)
        $0.imagePlacement = .right
        $0.setAction { [weak self] in
            self?.delegate?.showCalendar()
        }
        return $0
    }(DButton(type: .modalPicker))

    // MARK: Price

    private lazy var priceLabel = createHeaderLabel(L10n.Localizable.Offers.Create.Label.price)

    private lazy var priceCheckmarkGroup = {
        $0.onDidToggle = { [weak self] _, isChecked in
            self?.delegate?.isPriceNegotiableDidChange(isChecked)
        }
        return $0
    }(DCheckmarkGroup<Int>())

    private lazy var negitableCheckmark = {
        $0.setTitle(L10n.Localizable.Offers.Create.Checkmark.negotiablePrice)
        priceCheckmarkGroup.add(checkmark: $0, value: 0)
        return $0
    }(DCheckmark())

    private lazy var priceTextField: DValidatableTextField = {
        $0.configure(
            placeholder: L10n.Localizable.Offers.Create.Placeholder.price,
            correction: .no,
            keyboardType: .numberPad
        )
        $0.validator = RequiredValidator(PriceValidator())
        $0.onBeginEditing = { [weak self] _ in
            self?.delegate?.scrollToActiveView(self?.priceTextField)
        }
        $0.onTextChange = { [weak self] _ in
            guard let self else {
                return
            }
            self.delegate?.priceDidChange(self.priceTextField.currentText())
        }
        $0.formatter = DecimalTextFieldFormatter()
        $0.setUnit("₽/\(L10n.Plurals.day(1))")
        return $0
    }(DValidatableTextField())

    private(set) lazy var publishButton = {
        $0.title = L10n.Localizable.Offers.Create.Button.publish
        $0.setAction { [weak self] in
            self?.publish()
        }
        return $0
    }(DButton())

    // MARK: - Properties

    weak var delegate: CreateOfferViewDelegate?

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

    // MARK: - Configuration

    func setCalendarPlaceholder(active: Bool) {
        if active {
            calendarButton.title = L10n.Localizable.Offers.Create.Button.AvailableDates.placeholder
        } else {
            calendarButton.title = L10n.Localizable.Offers.Create.Button.AvailableDates.selected
        }
    }

    func setCityButton(title: String) {
        cityButton.title = title
    }

    func setPriceInput(visible: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.priceTextField.isHidden = !visible
            if !visible {
                self.priceTextField.setError(text: "")
            }
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
        let validatables = mainVStackView.arrangedSubviews.compactMap { $0 as? Validatable & UIView }
        if validatables.filter({ $0 != priceTextField }).allSatisfy({
            let isValid = $0.isValid()
            if !isValid {
                delegate?.scrollToInvalidView($0)
            }
            return isValid
        }) {
            if !negitableCheckmark.isOn && !priceTextField.isValid() {
                delegate?.scrollToInvalidView(priceTextField)
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                return
            }
            delegate?.publishOffer()
            return
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
        validatables.forEach { $0.isValid() }
    }
}
