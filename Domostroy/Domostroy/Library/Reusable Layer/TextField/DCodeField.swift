//
//  DCodeField.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 06.04.2025.
//

import UIKit
import SnapKit

final class DCodeField: UIView {

    // MARK: - Constants

    private enum Constants {
        static let hSpacing: CGFloat = 8
    }

    // MARK: - UI Elements

    private var codeFields: [DTextField] = []

    private lazy var fieldsStackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = Constants.hSpacing
        return $0
    }(UIStackView())

    // MARK: - Properties

    var onCodeCompleted: EmptyClosure?

    // MARK: - Init

    init(length: Int) {
        super.init(frame: .zero)
        codeFields = createFields(amount: length)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    private func setupUI() {
        addSubview(fieldsStackView)
        codeFields.forEach { fieldsStackView.addArrangedSubview($0) }

        fieldsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Public Methods

    func getCode() -> String {
        return codeFields.compactMap { $0.currentText() }.joined()
    }

    func focusFirstField() {
        codeFields.first?.responder.becomeFirstResponder()
    }
}

// MARK: - Private methods

private extension DCodeField {

    func createFields(amount: Int) -> [DSingleCharacterTextField] {
        var fields: [DSingleCharacterTextField] = []
        for fieldIndex in 0..<amount {
            let field = DSingleCharacterTextField()
            field.configure(placeholder: nil, correction: .no, keyboardType: .numberPad, mode: .oneTimeCode)

            field.onBeginEditing = { $0.selectAll(nil) }
            field.onBackspace = fieldIndex > 0 ? { _ in
                fields[fieldIndex - 1].responder.becomeFirstResponder()
            } : nil
            field.onTextChange = { [weak self] textField in
                self?.textFieldDidChange(textField)
            }

            fields.append(field)
        }

        for i in 0..<fields.count - 1 {
            fields[i].setNextResponder(fields[i + 1].responder)
        }
        return fields
    }

    func textFieldDidChange(_ textField: UITextField) {
        guard
            let fieldIndex = codeFields.firstIndex(where: { $0.responder == textField }),
            let currentText = textField.text
        else {
            return
        }

        if currentText.count > 1 {
            handlePastedText(currentText, currentFieldIndex: fieldIndex)
            return
        } else if currentText.count == 1 && fieldIndex < codeFields.count - 1 {
            self.codeFields[fieldIndex + 1].responder.becomeFirstResponder()
        }

        checkCodeCompletion()
    }

    func handlePastedText(_ text: String, currentFieldIndex: Int) {
        let maxLength = codeFields.count - currentFieldIndex
        let truncatedText = String(text.prefix(maxLength))
        let characters = Array(truncatedText)

        for (offset, char) in characters.enumerated() {
            let index = currentFieldIndex + offset
            if index < codeFields.count {
                codeFields[index].setText(String(char))
            }
        }

        let nextFieldIndex = min(currentFieldIndex + truncatedText.count, codeFields.count - 1)
        if nextFieldIndex < codeFields.count {
            self.codeFields[nextFieldIndex].responder.becomeFirstResponder()
        }

        checkCodeCompletion()
    }

    func checkCodeCompletion() {
        let code = getCode()
        if code.count == codeFields.count {
            codeFields.last?.responder.resignFirstResponder()
            onCodeCompleted?()
        }
    }
}
