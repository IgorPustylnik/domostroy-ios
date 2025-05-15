//
//  DMultiLineTextView.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 15.04.2025.
//

import UIKit
import SnapKit

class DMultiLineTextField: UIView {

    // MARK: - Constants

    fileprivate enum Constants {
        static let defaultCornerRadius: CGFloat = 14
        static let defaultContainerHeight: CGFloat = 52
        static let defaultMaxContainerHeight: CGFloat = 200
        static let toolbarHeight: CGFloat = 44
        static let fieldStrokeWidth: CGFloat = 1.0
        static let fieldMargin = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        static let borderColor: UIColor = .separator
        static let hightlightedBorderColor: UIColor = .label

        static let animationDuration: TimeInterval = 0.3
    }

    // MARK: - Public Properties

    var cornerRadius: CGFloat = Constants.defaultCornerRadius {
        didSet {
            textViewContainer.layer.cornerRadius = cornerRadius
        }
    }

    var maxHeight: CGFloat = Constants.defaultMaxContainerHeight

    var onBeginEditing: ((UITextView) -> Void)?
    var onTextChange: ((UITextView) -> Void)?
    var onEndEditing: ((UITextView) -> Void)?
    var onShouldReturn: ((UITextView) -> Void)?
    var responder: UIResponder {
        return self.textView
    }

    // MARK: - Properties

    private var nextInput: UIResponder?
    var isTextViewEditing = false

    // MARK: - UI Elements

    fileprivate lazy var textViewContainer = {
        $0.backgroundColor = .systemBackground
        $0.layer.borderColor = Constants.borderColor.cgColor
        $0.layer.borderWidth = Constants.fieldStrokeWidth
        $0.clipsToBounds = true
        return $0
    }(UIView())

    fileprivate lazy var textFieldInputAccessoryView: UIView = {
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

    fileprivate lazy var textView = {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .label
        $0.tintColor = .label
        $0.inputAccessoryView = textFieldInputAccessoryView
        $0.delegate = self
        return $0
    }(UITextView())

    fileprivate lazy var placeholderLabel = {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .placeholderText
        $0.isUserInteractionEnabled = false
        return $0
    }(UILabel())

    private var containerHeightConstraint: Constraint?

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        registerForTraitChanges(
            [UITraitUserInterfaceStyle.self]
        ) { [weak self] (_: Self, _: UITraitCollection) in
            self?.updateCGColors()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func configure(
        placeholder: String?,
        correction: UITextAutocorrectionType,
        keyboardType: UIKeyboardType,
        autocapitalizationType: UITextAutocapitalizationType
    ) {
        placeholderLabel.text = placeholder
        cornerRadius = Constants.defaultCornerRadius
        textView.autocorrectionType = correction
        textView.keyboardType = keyboardType
        textView.autocapitalizationType = autocapitalizationType
    }

    /// Sets next responder, which will be activated after 'Next' button in keyboard will be pressed
    func setNextResponder(_ nextResponder: UIResponder) {
        textView.returnKeyType = .next
        nextInput = nextResponder
    }

    func setText(_ text: String) {
        textView.text = text
    }

    func currentText() -> String {
        return textView.text ?? ""
    }

    // MARK: - Protected Methods

    fileprivate func setupUI() {
        addSubview(textViewContainer)
        textViewContainer.addSubview(textView)
        textViewContainer.addSubview(placeholderLabel)

        textViewContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        textView.textContainerInset = .init(top: Constants.fieldMargin.top, left: 0, bottom: 0, right: 0)
        textView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(Constants.fieldMargin)
            self.containerHeightConstraint = make.height.equalTo(Constants.defaultContainerHeight).constraint
        }
        placeholderLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.fieldMargin)
            make.centerY.equalToSuperview()
        }
    }

    fileprivate func updateCGColors() {
        UIView.animate(withDuration: Constants.animationDuration) {
            if self.isTextViewEditing {
                self.textViewContainer.layer.borderColor = Constants.hightlightedBorderColor.cgColor
            } else {
                self.textViewContainer.layer.borderColor = Constants.borderColor.cgColor
            }
        }
    }

    fileprivate func updateContainerSize() {
        let fittingSize = CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude)
        var expectedHeight = textView.sizeThatFits(
            fittingSize
        ).height + Constants.fieldMargin.top
        expectedHeight = max(expectedHeight, Constants.defaultContainerHeight)

        let clampedHeight = min(expectedHeight, maxHeight)
        if clampedHeight == maxHeight {
            textView.textContainerInset.bottom = Constants.fieldMargin.bottom
        } else {
            textView.textContainerInset.bottom = 0
        }
        containerHeightConstraint?.update(offset: clampedHeight)
    }
}

// MARK: - UITextViewDelegate

extension DMultiLineTextField: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.alpha = 0
        isTextViewEditing = true
        onBeginEditing?(textView)
        updateCGColors()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.alpha = textView.text.isEmpty ? 1 : 0
        isTextViewEditing = false
        onEndEditing?(textView)
        updateCGColors()
    }

    func textViewDidChange(_ textView: UITextView) {
        onTextChange?(textView)
        updateContainerSize()
    }

}

// MARK: - DValidatableMultilineTextField

final class DValidatableMultilineTextField: DMultiLineTextField, Validatable {

    // MARK: - UI Elements

    private lazy var errorLabel: UILabel = {
        $0.alpha = 0
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .systemRed
        return $0
    }(UILabel())

    // MARK: - Properties

    var validator: TextValidator?

    private var isErrorState = false

    // MARK: - Overrides

    override func setupUI() {
        super.setupUI()
        addSubview(errorLabel)

        textViewContainer.snp.remakeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(textViewContainer.snp.bottom)
            make.leading.equalTo(snp.leading).offset(Constants.fieldMargin.left)
            make.trailing.equalTo(snp.trailing)
            make.bottom.equalToSuperview()
        }
    }

    override func updateCGColors() {
        UIView.animate(withDuration: Constants.animationDuration) {
            if self.isErrorState {
                self.textViewContainer.layer.borderColor = UIColor.systemRed.cgColor
                return
            }
            if self.isTextViewEditing {
                self.textViewContainer.layer.borderColor = Constants.hightlightedBorderColor.cgColor
            } else {
                self.textViewContainer.layer.borderColor = Constants.borderColor.cgColor
            }
        }
    }

    override func textViewDidEndEditing(_ textView: UITextView) {
        validate()
        super.textViewDidEndEditing(textView)
    }

    // MARK: - Public Methods

    @discardableResult
    func isValid() -> Bool {
        if !isErrorState {
            validate()
        }
        return !isErrorState
    }

    func setError(text: String?) {
        errorLabel.text = text
        if let text {
            isErrorState = !text.isEmpty
        }

        setNeedsLayout()
        invalidateIntrinsicContentSize()

        UIView.animate(withDuration: Constants.animationDuration) {
            self.errorLabel.alpha = self.isErrorState ? 1.0 : 0.0
        }
        updateCGColors()
    }

    // MARK: - Private Methods

    private func validate() {
        guard let validator = validator else {
            isErrorState = false
            setError(text: "")
            return
        }
        let (isValid, errorMessage) = validator.validate(textView.text)
        isErrorState = !isValid
        setError(text: errorMessage)
    }

    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        isErrorState = false
        setError(text: nil)
    }
}

// MARK: - Selectors

private extension DMultiLineTextField {
    @objc
    func doneButtonTapped() {
        if let nextField = nextInput {
            nextField.becomeFirstResponder()
        } else {
            textView.resignFirstResponder()
            onShouldReturn?(textView)
        }
    }
}
