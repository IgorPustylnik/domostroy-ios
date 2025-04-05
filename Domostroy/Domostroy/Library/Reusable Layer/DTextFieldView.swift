//
//  textFieldView.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 04.04.2025.
//

import UIKit
import SnapKit

final class DTextFieldView: UIView {

    // MARK: - Mode

    enum Mode {
        case name
        case surname
        case email
        case phoneNumber
        case password

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
            }
        }
    }

    // MARK: - Constants

    private enum Constants {
        static let containerHeight: CGFloat = 52
        static let errorLabelPadding = UIEdgeInsets(top: 5.0, left: 14.0, bottom: 0, right: 0)
        static let defaultCornerRadius: CGFloat = 14

        static let fieldStrokeWidth: CGFloat = 1.0
        static let fieldMargin = UIEdgeInsets(top: 20, left: 14.0, bottom: 20, right: 14)
        static let errorHeight: CGFloat = 12

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
    var onEndEditing: ((UITextField) -> Void)?
    var onShouldReturn: ((UITextField) -> Void)?
    var responder: UIResponder {
        return self.textField
    }
    var validator: TextValidator?

    // MARK: - Private Properties

    private var nextInput: UIResponder?
    private var isErrorState = false

    private var isHideable: Bool = false {
        didSet {
            eyeButton.isHidden = !isHideable
            updateTextFieldTrailingConstraint()
        }
    }

    private var textFieldTrailingConstraint: Constraint?

    // MARK: - UI Elements

    private lazy var textFieldContainer: UIView = {
        $0.backgroundColor = .systemBackground
        $0.layer.borderColor = Constants.borderColor.cgColor
        $0.layer.borderWidth = Constants.fieldStrokeWidth
        return $0
    }(UIView())

    private lazy var textField: UITextField = {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .label
        $0.tintColor = .label
        $0.autocapitalizationType = .none
        $0.delegate = self
        $0.addTarget(self, action: #selector(textfieldEditingChange(_:)), for: .editingChanged)
        return $0
    }(UITextField())

    private lazy var eyeButton: DButton = {
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

    private lazy var errorLabel: UILabel = {
        $0.alpha = 0
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .systemRed
        return $0
    }(UILabel())

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

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override var intrinsicContentSize: CGSize {
        let errorHeight: CGFloat = isErrorState ? Constants.errorHeight : 0
        return CGSize(
            width: UIView.noIntrinsicMetric,
            height: Constants.containerHeight + errorHeight
        )
    }

    // MARK: - Internal Methods

    func configure(
        placeholder: String?,
        correction: UITextAutocorrectionType,
        keyboardType: UIKeyboardType,
        mode: DTextFieldView.Mode
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

    /// Method will update UI and return
    @discardableResult
    func isValid() -> Bool {
        if !isErrorState {
            // case if user didn't activate this text field
            validate()
        }
        return !isErrorState
    }

    func currentText() -> String {
        return textField.text ?? ""
    }

}

// MARK: - Configuration

private extension DTextFieldView {

    func setupUI() {
        addSubview(textFieldContainer)
        addSubview(errorLabel)
        textFieldContainer.addSubview(textField)
        textFieldContainer.addSubview(eyeButton)

        textFieldContainer.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.containerHeight)
        }
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.fieldMargin)
            make.top.bottom.equalToSuperview()
            isHideable = isHideable
        }
        eyeButton.snp.makeConstraints { make in
            make.centerY.equalTo(textField)
            make.size.equalTo(Constants.eyeSize)
            make.trailing.equalTo(textFieldContainer).inset(Constants.fieldMargin.right)
        }
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(textFieldContainer.snp.bottom)
            make.leading.equalTo(snp.leading).offset(Constants.fieldMargin.left)
            make.trailing.equalTo(snp.trailing)
        }
    }

    func updateCGColors() {
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

    func updateTextFieldTrailingConstraint() {
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

// MARK: - Private Methods

private extension DTextFieldView {

    func validate() {
        guard let validator = validator else {
            isErrorState = false
            setError(text: "")
            return
        }
        let (isValid, errorMessage) = validator.validate(textField.text)
        isErrorState = !isValid
        setError(text: errorMessage)
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

    @objc
    func textfieldEditingChange(_ textField: UITextField) {
        isErrorState = false
        setError(text: nil)
    }

}

// MARK: - UITextFieldDelegate

extension DTextFieldView: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        onBeginEditing?(textField)
        updateCGColors()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        validate()
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
}
