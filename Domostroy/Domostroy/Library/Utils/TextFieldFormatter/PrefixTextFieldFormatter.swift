//
//  PrefixTextFieldFormatter.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 17.05.2025.
//

import UIKit

final class PrefixTextFieldFormatter: TextFieldFormatter {

    // MARK: - Properties

    private(set) var rawText: String = ""
    private let prefix: String
    private let nestedFormatter: TextFieldFormatter?

    // MARK: - Init

    init(prefix: String, nestedFormatter: TextFieldFormatter? = nil) {
        self.prefix = prefix
        self.nestedFormatter = nestedFormatter
    }

    // MARK: - TextFieldFormatter

    func format(text: String) -> String {
        if text.isEmpty {
            rawText = ""
            return ""
        }

        if text.hasPrefix(prefix) {
            let textAfterPrefix = String(text.dropFirst(prefix.count))
            let formattedAfterPrefix = nestedFormatter?.format(text: textAfterPrefix) ?? textAfterPrefix
            rawText = formattedAfterPrefix
            return formattedAfterPrefix.isEmpty ? "" : prefix + formattedAfterPrefix
        }

        rawText = text
        let formattedText = nestedFormatter?.format(text: text) ?? text
        return formattedText.isEmpty ? "" : prefix + formattedText
    }

    func shouldChangeCharacters(
        in textField: UITextField,
        range: NSRange,
        replacementString string: String
    ) -> (newText: String, shouldChange: Bool) {
        guard let currentText = textField.text else {
            return (string.isEmpty ? "" : prefix + string, true)
        }

        if string.isEmpty && range.length > 0 &&
            currentText.count == prefix.count + 1 &&
            range.location == prefix.count {
            rawText = ""
            return ("", false)
        }

        if currentText.isEmpty && !string.isEmpty {
            rawText = string
            return (prefix + string, false)
        }

        if range.location < prefix.count {
            return (currentText, false)
        }

        let textAfterPrefix = String(currentText.dropFirst(prefix.count))

        let adjustedRange = NSRange(
            location: range.location - prefix.count,
            length: range.length
        )

        if let nestedFormatter = nestedFormatter {
            let tempTextField = UITextField()
            tempTextField.text = textAfterPrefix

            let (newFormattedContent, _) = nestedFormatter.shouldChangeCharacters(
                in: tempTextField,
                range: adjustedRange,
                replacementString: string
            )

            rawText = nestedFormatter.rawText

            let newText = newFormattedContent.isEmpty ? "" : prefix + newFormattedContent

            if string.isEmpty && range.length > 0 && !newFormattedContent.isEmpty {
                DispatchQueue.main.async {
                    self.setCursorPosition(in: textField, at: range.location)
                }
            }

            return (newText, false)
        } else {
            let nsString = textAfterPrefix as NSString
            let newContentAfterPrefix = nsString.replacingCharacters(in: adjustedRange, with: string)
            rawText = newContentAfterPrefix

            let newFullText = newContentAfterPrefix.isEmpty ? "" : prefix + newContentAfterPrefix

            if string.isEmpty && range.length > 0 && !newContentAfterPrefix.isEmpty {
                DispatchQueue.main.async {
                    self.setCursorPosition(in: textField, at: range.location)
                }
            }

            return (newFullText, false)
        }
    }

    // MARK: - Private methods

    private func setCursorPosition(in textField: UITextField, at position: Int) {
        guard let text = textField.text else {
            return
        }

        let newPosition = max(prefix.count, min(position, text.count))

        guard let cursorPosition = textField.position(from: textField.beginningOfDocument, offset: newPosition) else {
            return
        }

        textField.selectedTextRange = textField.textRange(from: cursorPosition, to: cursorPosition)
    }
}
