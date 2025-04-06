//
//  DTextField.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 04.04.2025.
//

import UIKit
import SnapKit

// MARK: - UIBackspaceDetectingTextField

private final class UIBackspaceDetectingTextField: UITextField {

    override func deleteBackward() {
        super.deleteBackward()
        onBackspace?(self)
    }

    var onBackspace: ((UITextField) -> Void)?
}

// MARK: - DTextField

class DTextField: UIView {

    // MARK: - Mode

    enum Mode {
        case name
        case surname
        case email
        case phoneNumber
        case password
        case oneTimeCode

        var contentType: UITextContentType {
            switch self {
            case .name:
                return .name
            case .surname:
                return .familyName
            case .email:
                return .emailAddress
            case .phoneNumber:
                return .telephoneNumber
            case .password:
                return .password
            case .oneTimeCode:
                return .oneTimeCode
            }
        }
    }

    // MARK: - Constants

    fileprivate enum Constants {
        static let containerHeight: CGFloat = 52
        static let defaultCornerRadius: CGFloat = 14

        static let fieldStrokeWidth: CGFloat = 1.0
        static let fieldMargin = UIEdgeInsets(top: 20, left: 14.0, bottom: 20, right: 14)

        static let borderColor: UIColor = .systemGray3
        static let hightlightedBorderColor: UIColor = .label

        static let eyeLeftPadding: CGFloat = 6
        static let eyeSize: CGFloat = 24
        static let eyeImage: UIImage = .TextField.eye.withTintColor(
            .Domostroy.primary,
            renderingMode: .alwaysOriginal
        )
        static let eyeSlashImage: UIImage = .TextField.eyeSlash.withTintColor(
            .Domostroy.primary,
            renderingMode: .alwaysOriginal
        )

        static let animationDuration: TimeInterval = 0.3
    }

    // MARK: - Public Properties

    var cornerRadius: CGFloat = Constants.defaultCornerRadius {
        didSet {
            textFieldContainer.layer.cornerRadius = cornerRadius
        }
    }

    var onBeginEditing: ((UITextField) -> Void)?
    var onTextChange: ((UITextField) -> Void)?
    var onEndEditing: ((UITextField) -> Void)?
    var onShouldReturn: ((UITextField) -> Void)?
    var onBackspace: ((UITextField) -> Void)? {
        didSet {
            textField.onBackspace = { [weak self] textField in self?.onBackspace?(textField) }
        }
    }
    var responder: UIResponder {
        return self.textField
    }

    // MARK: - Properties

    fileprivate var nextInput: UIResponder?

    fileprivate var isHideable: Bool = false {
        didSet {
            updateTextFieldTrailingConstraint()
        }
    }

    private var textFieldTrailingConstraint: Constraint?

    // MARK: - UI Elements

    fileprivate lazy var textFieldContainer: UIView = {
        $0.backgroundColor = .systemBackground
        $0.layer.borderColor = Constants.borderColor.cgColor
        $0.layer.borderWidth = Constants.fieldStrokeWidth
        $0.clipsToBounds = true
        return $0
    }(UIView())

    fileprivate lazy var textField: UIBackspaceDetectingTextField = {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .label
        $0.tintColor = .label
        $0.autocapitalizationType = .none
        $0.delegate = self
        return $0
    }(UIBackspaceDetectingTextField())

    fileprivate lazy var eyeButton: DButton = {
        $0.image = .TextField.eye.withTintColor(.Domostroy.primary, renderingMode: .alwaysOriginal)
        $0.isHidden = true
        $0.setAction { [weak self] in
            self?.textField.isSecureTextEntry.toggle()
            guard let isSecure = self?.textField.isSecureTextEntry else {
                return
            }
            self?.eyeButton.image = isSecure ?
            Constants.eyeImage : Constants.eyeSlashImage
        }
        return $0
    }(DButton(type: .plainPrimary))

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        registerForTraitChanges(
            [UITraitUserInterfaceStyle.self]
        ) { [weak self] (_: Self, _: UITraitCollection) in
            self?.updateCGColors()
        }
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(
            width: UIView.noIntrinsicMetric,
            height: textFieldContainer.frame.height
        )
    }

    // MARK: - Public Methods

    func configure(
        placeholder: String?,
        correction: UITextAutocorrectionType,
        keyboardType: UIKeyboardType,
        mode: Mode
    ) {
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.placeholderText,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)
            ]
        )
        cornerRadius = Constants.defaultCornerRadius
        textField.autocorrectionType = correction
        textField.keyboardType = keyboardType
        textField.textContentType = mode.contentType
        textField.isSecureTextEntry = mode == .password
        isHideable = mode == .password
    }

    /// Sets next responder, which will be activated after 'Next' button in keyboard will be pressed
    func setNextResponder(_ nextResponder: UIResponder) {
        textField.returnKeyType = .next
        nextInput = nextResponder
    }

    func setText(_ text: String) {
        textField.text = text
    }

    func currentText() -> String {
        return textField.text ?? ""
    }

    // MARK: - Protected Methods

    fileprivate func setupUI() {
        addSubview(textFieldContainer)
        textFieldContainer.addSubview(textField)
        textFieldContainer.addSubview(eyeButton)

        textFieldContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.greaterThanOrEqualTo(Constants.containerHeight)
        }
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.fieldMargin)
            make.top.bottom.equalToSuperview()
            updateTextFieldTrailingConstraint()
        }
        eyeButton.snp.makeConstraints { make in
            make.centerY.equalTo(textField)
            make.size.equalTo(Constants.eyeSize)
            make.trailing.equalTo(textFieldContainer).inset(Constants.fieldMargin.right)
        }
    }

    fileprivate func updateCGColors() {
        UIView.animate(withDuration: Constants.animationDuration) {
            if self.textField.isEditing {
                self.textFieldContainer.layer.borderColor = Constants.hightlightedBorderColor.cgColor
            } else {
                self.textFieldContainer.layer.borderColor = Constants.borderColor.cgColor
            }
        }
    }

    fileprivate func updateTextFieldTrailingConstraint() {
        eyeButton.isHidden = !isHideable
        textFieldTrailingConstraint?.deactivate()
        textField.snp.makeConstraints { make in
            if isHideable {
                textFieldTrailingConstraint = make.trailing.equalTo(eyeButton.snp.leading)
                    .inset(-Constants.eyeLeftPadding).constraint
            } else {
                textFieldTrailingConstraint = make.trailing.equalToSuperview()
                    .inset(Constants.fieldMargin.right).constraint
            }
        }
        textFieldTrailingConstraint?.activate()
    }
}

// MARK: - UITextFieldDelegate

extension DTextField: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        onBeginEditing?(textField)
        updateCGColors()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        onEndEditing?(textField)
        updateCGColors()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = nextInput {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            onShouldReturn?(textField)
            return true
        }
        return false
    }

    @objc
    func textFieldEditingChanged(_ textField: UITextField) {
        onTextChange?(textField)
    }

}

// MARK: - DValidatableTextField

final class DValidatableTextField: DTextField {

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

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        let errorHeight: CGFloat = isErrorState ? errorLabel.frame.height : 0
        return CGSize(
            width: UIView.noIntrinsicMetric,
            height: textFieldContainer.frame.height + errorHeight - 2
        )
    }

    override func setupUI() {
        super.setupUI()

        addSubview(errorLabel)

        textFieldContainer.snp.remakeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(Constants.containerHeight)
        }

        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(textFieldContainer.snp.bottom)
            make.leading.equalTo(snp.leading).offset(Constants.fieldMargin.left)
            make.trailing.equalTo(snp.trailing)
            make.bottom.equalToSuperview()
        }
    }

    override func updateCGColors() {
        UIView.animate(withDuration: Constants.animationDuration) {
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
    }

    override func textFieldDidEndEditing(_ textField: UITextField) {
        validate()
        super.textFieldDidEndEditing(textField)
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
        let (isValid, errorMessage) = validator.validate(textField.text)
        isErrorState = !isValid
        setError(text: errorMessage)
    }

    override func textFieldEditingChanged(_ textField: UITextField) {
        super.textFieldEditingChanged(textField)
        isErrorState = false
        setError(text: nil)
    }
}

// MARK: - DSingleCharacterTextField

final class DSingleCharacterTextField: DTextField {

    override func configure(
        placeholder: String?,
        correction: UITextAutocorrectionType,
        keyboardType: UIKeyboardType,
        mode: Mode
    ) {
        super.configure(placeholder: placeholder, correction: correction, keyboardType: keyboardType, mode: mode)
        textField.font = .systemFont(ofSize: 48, weight: .thin)
        textField.textAlignment = .center
    }

}
