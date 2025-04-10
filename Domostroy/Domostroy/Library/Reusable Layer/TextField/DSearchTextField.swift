//
//  DSearchTextField.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 10.04.2025.
//

import UIKit
import SnapKit

final class DSearchTextField: UIView {

    // MARK: - Constants

    private enum Constants {
        static let containerHeight: CGFloat = 48
        static let defaultCornerRadius: CGFloat = 18

        static let fieldStrokeWidth: CGFloat = 1.0
        static let fieldMargin = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)

        static let borderColor: UIColor = .systemGray3
        static let cancelButtonPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        static let leftImageSize: CGSize = .init(width: 24, height: 24)
        static let clearButtonSize: CGSize = .init(width: 20, height: 20)
        static let clearButtonImageSize: CGSize = .init(width: 10, height: 10)
        static let clearButtonPadding: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)

        static let animationDuration: TimeInterval = 0.3
    }

    // MARK: - Public Properties

    var cornerRadius: CGFloat = Constants.defaultCornerRadius {
        didSet {
            textFieldContainer.layer.cornerRadius = cornerRadius
        }
    }

    // TODO: Localize
    var placeholder: String = "Search" {
        didSet {
            textField.placeholder = placeholder
        }
    }

    var onBeginEditing: ((UITextField) -> Void)?
    var onTextChange: ((UITextField) -> Void)?
    var onEndEditing: ((UITextField) -> Void)?
    var onShouldReturn: ((UITextField) -> Void)?
    var onCancel: ((UITextField) -> Void)?
    var responder: UIResponder {
        return self.textField
    }

    // MARK: - Properties

    private var isActive: Bool = false {
        didSet {
            updateIsActive()
        }
    }

    private var containerTrailingConstraint: Constraint?

    // MARK: - UI Elements

    private lazy var textFieldContainer = {
        $0.backgroundColor = .systemBackground
        $0.layer.borderColor = Constants.borderColor.cgColor
        $0.layer.borderWidth = Constants.fieldStrokeWidth
        $0.clipsToBounds = true
        return $0
    }(UIView())

    private lazy var leftImageView = {
        $0.image = .TextField.search.withTintColor(
            isActive ? .secondaryLabel : .placeholderText,
            renderingMode: .alwaysOriginal
        )
        return $0
    }(UIImageView())

    private lazy var textField = {
        $0.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.placeholderText,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)
            ]
        )
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .label
        $0.tintColor = .label
        $0.autocapitalizationType = .none
        $0.delegate = self
        $0.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        return $0
    }(UITextField())

    private lazy var clearButton = {
        $0.image = .TextField.xmark.withTintColor(.label, renderingMode: .alwaysOriginal)
        $0.setAction { [weak self] in
            self?.textField.text = ""
            self?.updateIsActive()
        }
        $0.imageSize = Constants.clearButtonImageSize
        $0.isHidden = !isActive || currentText().isEmpty
        return $0
    }(DButton(type: .plain))

    private lazy var cancelButton = {
        // TODO: Localize
        $0.title = "Cancel"
        $0.insets = .zero
        $0.setAction { [weak self] in
            guard let self else {
                return
            }
            self.textFieldCancelled(self.textField)
        }
        $0.isHidden = !isActive
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        return $0
    }(DButton(type: .plainPrimary))

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        trackTraitChanges()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(
            width: frame.width,
            height: textFieldContainer.frame.height
        )
    }

    // MARK: - Public Methods

    func setText(_ text: String) {
        textField.text = text
    }

    func currentText() -> String {
        return textField.text ?? ""
    }

    // MARK: - Private methods

    private func setupUI() {
        addSubview(cancelButton)
        addSubview(textFieldContainer)
        textFieldContainer.addSubview(leftImageView)
        textFieldContainer.addSubview(textField)
        textFieldContainer.addSubview(clearButton)

        textFieldContainer.layer.cornerRadius = cornerRadius

        textFieldContainer.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.height.equalTo(Constants.containerHeight).priority(.medium)
            self.containerTrailingConstraint = make.trailing.equalToSuperview().constraint
        }
        leftImageView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview().inset(Constants.fieldMargin)
            make.size.equalTo(Constants.leftImageSize)
        }
        textField.snp.makeConstraints { make in
            make.leading.equalTo(leftImageView.snp.trailing).offset(Constants.fieldMargin.left)
            make.trailing.equalTo(clearButton.snp.leading).inset(-Constants.cancelButtonPadding.left)
            make.verticalEdges.equalToSuperview()
        }
        clearButton.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview().inset(Constants.clearButtonPadding)
            make.trailing.equalToSuperview().inset(Constants.clearButtonPadding)
            make.size.equalTo(Constants.clearButtonSize)
        }
        cancelButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    private func updateCGColors() {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.textFieldContainer.layer.borderColor = Constants.borderColor.cgColor
        }
    }

    private func updateIsActive() {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.cancelButton.isHidden = !self.isActive
            self.clearButton.isHidden = !self.isActive || self.currentText().isEmpty
            self.leftImageView.image = .TextField.search.withTintColor(
                self.isActive ? .secondaryLabel : .placeholderText,
                renderingMode: .alwaysOriginal
            )
        }
        updateContainerTrailingConstraint()
    }

    private func updateContainerTrailingConstraint() {
        containerTrailingConstraint?.deactivate()

        UIView.animate(withDuration: Constants.animationDuration) {
            if self.isActive {
                self.textFieldContainer.snp.remakeConstraints { make in
                    make.leading.top.bottom.equalToSuperview()
                    make.height.equalTo(Constants.containerHeight).priority(.medium)
                    self.containerTrailingConstraint = make.trailing
                        .equalTo(self.cancelButton.snp.leading)
                        .offset(-Constants.cancelButtonPadding.left)
                        .constraint
                }
            } else {
                self.textFieldContainer.snp.remakeConstraints { make in
                    make.leading.top.bottom.equalToSuperview()
                    make.height.equalTo(Constants.containerHeight).priority(.medium)
                    self.containerTrailingConstraint = make.trailing.equalToSuperview().constraint
                }
            }
            self.setNeedsLayout()
            self.layoutIfNeeded()
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

// MARK: - UITextFieldDelegate

extension DSearchTextField: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        isActive = true
        onBeginEditing?(textField)
        updateCGColors()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        isActive = false
        onEndEditing?(textField)
        updateCGColors()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        onShouldReturn?(textField)
        return true
    }

    @objc
    func textFieldEditingChanged(_ textField: UITextField) {
        clearButton.isHidden = currentText().isEmpty
        onTextChange?(textField)
    }

    func textFieldCancelled(_ textField: UITextField) {
        textField.resignFirstResponder()
        onCancel?(textField)
    }

}
