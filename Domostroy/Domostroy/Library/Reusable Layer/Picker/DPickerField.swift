//
//  DPickerField.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 16.04.2025.
//

import UIKit
import SnapKit

class DPickerField: UIView, Validatable {

    // MARK: - Constants

    private enum Constants {
        static let borderColor: UIColor = .separator
        static let hightlightedBorderColor: UIColor = .label
        static let containerHeight: CGFloat = 52
        static let toolbarHeight: CGFloat = 44
        static let containerInsets: UIEdgeInsets = .init(top: 14, left: 14, bottom: 14, right: 14)
        static let defaultCornerRadius: CGFloat = 14
        static let borderWidth: CGFloat = 1
        static let animationDuration: Double = 0.3
    }

    // MARK: - UI Elements

    private lazy var textFieldContainer = {
        $0.backgroundColor = .secondarySystemBackground
        $0.layer.cornerRadius = Constants.defaultCornerRadius
        $0.layer.borderWidth = Constants.borderWidth
        $0.layer.borderColor = UIColor.separator.cgColor
        return $0
    }(UIView())

    private lazy var textField = {
        $0.tintColor = .clear
        $0.inputView = picker
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.inputAccessoryView = textFieldInputAccessoryView
        $0.delegate = self
        return $0
    }(UnselectableTextField())

    private lazy var rightChevronButton = {
        $0.insets = .zero
        $0.image = .Picker.chevronDown.withTintColor(.label, renderingMode: .alwaysOriginal)
        $0.setAction { [weak self] in
            guard let textField = self?.textField else {
                return
            }
            if textField.isFirstResponder {
                textField.resignFirstResponder()
            } else {
                textField.becomeFirstResponder()
            }
        }
        return $0
    }(DButton(type: .plain))

    private lazy var picker = {
        $0.delegate = self
        $0.dataSource = self
        return $0
    }(UIPickerView())

    private lazy var errorLabel = {
        $0.alpha = 0
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .systemRed
        return $0
    }(UILabel())

    private lazy var textFieldInputAccessoryView: UIView = {
        let toolbar = UIToolbar(
            frame: .init(
                x: 0,
                y: 0,
                width: UIApplication.topViewController()?.view.frame.width ?? 0,
                height: Constants.toolbarHeight
            )
        )
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(
            title: L10n.Localizable.Common.Button.done,
            style: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
        toolbar.items = [flexSpace, doneButton]
        return toolbar
    }()

    // MARK: - Properties

    private var items: [String] = [] {
        didSet {
            picker.reloadAllComponents()
        }
    }

    private var placeholderIndex: Int = 0 {
        didSet {
            if placeholderIndex >= 0 {
                selectedIndex = placeholderIndex
            }
            updateText()
        }
    }

    private var isErrorState: Bool = false

    private(set) var selectedIndex: Int = 0 {
        didSet {
            updateText()
        }
    }

    var responder: UIResponder {
        textField
    }

    var requiresNonPlaceholder: Bool = false
    var errorMessage: String?

    var onPick: ((DPickerField) -> Void)?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        trackTraitChanges()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    private func setupUI() {
        addSubview(textFieldContainer)
        textFieldContainer.addSubview(textField)
        textFieldContainer.addSubview(rightChevronButton)
        addSubview(errorLabel)

        textFieldContainer.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.containerHeight)
        }
        rightChevronButton.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalToSuperview().inset(Constants.containerInsets)
        }
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(
                UIEdgeInsets(
                    top: 0,
                    left: Constants.containerInsets.left,
                    bottom: 0,
                    right: Constants.containerInsets.right
                )
            )
        }

        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(textFieldContainer.snp.bottom)
            make.leading.equalTo(snp.leading).offset(Constants.containerInsets.left)
            make.trailing.equalTo(snp.trailing)
            make.bottom.equalToSuperview()
        }
    }

    // MARK: - Public methods

    func setItems(_ newItems: [String], selectedIndex: Int = 0, placeholderIndex: Int = 0) {
        self.items = newItems
        self.placeholderIndex = placeholderIndex
        self.selectedIndex = selectedIndex
        picker.selectRow(selectedIndex, inComponent: 0, animated: false)
        updateText()
    }

    func currentText() -> String {
        return textField.text ?? ""
    }

    @discardableResult
    func isValid() -> Bool {
        if !isErrorState {
            validate()
        }
        return !isErrorState
    }

    // MARK: - Private methods

    private func setError(text: String?) {
        errorLabel.text = text
        if let text {
            isErrorState = !text.isEmpty
        }

        UIView.animate(withDuration: Constants.animationDuration) {
            self.errorLabel.alpha = self.isErrorState ? 1.0 : 0.0
        }
        updateCGColors()
    }

    private func validate() {
        let isPlaceholder = selectedIndex == placeholderIndex
        let isEmpty = currentText().isEmpty

        isErrorState = isEmpty || (requiresNonPlaceholder && isPlaceholder)
        if isErrorState {
            setError(text: errorMessage ?? L10n.Localizable.ValidationError.required)
        } else {
            setError(text: nil)
        }
    }

    private func updateText() {
        guard selectedIndex >= 0 && selectedIndex < items.count else {
            return
        }
        textField.textColor = selectedIndex == placeholderIndex ? .placeholderText : .label
        textField.text = items[selectedIndex]
    }

    private func updateCGColors() {
        if self.isErrorState {
            self.textFieldContainer.layer.borderColor = UIColor.systemRed.cgColor
            return
        }
        if self.textField.isEditing {
            self.textFieldContainer.layer.borderColor = Constants.hightlightedBorderColor.cgColor
        } else {
            self.textFieldContainer.layer.borderColor = Constants.borderColor.cgColor
        }
    }

    private func trackTraitChanges() {
        registerForTraitChanges(
            [UITraitUserInterfaceStyle.self]
        ) { [weak self] (_: Self, _: UITraitCollection) in
            self?.updateCGColors()
        }
    }

}

// MARK: - UIPickerViewDelegate

extension DPickerField: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
        updateCGColors()
        onPick?(self)
    }
}

// MARK: - UIPickerViewDataSource

extension DPickerField: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
}

// MARK: - UITextFieldDelegate

extension DPickerField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateCGColors()
        rightChevronButton.image = .Picker.chevronUp
            .withTintColor(.label, renderingMode: .alwaysOriginal)

    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        validate()
        rightChevronButton.image = .Picker.chevronDown
            .withTintColor(.label, renderingMode: .alwaysOriginal)
    }
}

// MARK: - Selectors

private extension DPickerField {
    @objc
    func doneButtonTapped() {
        textField.resignFirstResponder()
        validate()
    }
}

// MARK: - UnselectableTextField

private final class UnselectableTextField: UITextField, UIEditMenuInteractionDelegate {
    override func buildMenu(with builder: any UIMenuBuilder) {
        builder.remove(menu: .autoFill)
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }

    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }

    override func caretRect(for position: UITextPosition) -> CGRect {
        return .zero
    }
}
