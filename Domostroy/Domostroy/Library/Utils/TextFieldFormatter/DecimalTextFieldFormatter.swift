//
//  DecimalTextFieldFormatter.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 17.05.2025.
//

import Foundation
import UIKit

final class DecimalTextFieldFormatter: TextFieldFormatter {

    // MARK: - Properties

    private(set) var rawText: String = ""
    private let decimalSeparator: Character = NumberFormatter().decimalSeparator.first ?? "."
    private lazy var allowedCharacters = "0123456789\(decimalSeparator)"

    // MARK: - TextFieldFormatter

    func format(text: String) -> String {
        let filtered = text.filter { allowedCharacters.contains($0) }
        rawText = filtered
        return filtered
    }

    func shouldChangeCharacters(
        in textField: UITextField,
        range: NSRange,
        replacementString string: String
    ) -> (newText: String, shouldChange: Bool) {
        guard let text = textField.text,
              let textRange = Range(range, in: text)
        else {
            return (textField.text ?? "", false)
        }

        let allowedCharacters = CharacterSet(charactersIn: allowedCharacters)
        if string.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            return (text, false)
        }

        let updatedText = text.replacingCharacters(in: textRange, with: string)

        let dots = updatedText.filter { $0 == decimalSeparator }.count
        if dots > 1 {
            return (text, false)
        }

        if let dotIndex = updatedText.firstIndex(of: decimalSeparator) {
            let fractionalPart = updatedText[updatedText.index(after: dotIndex)...]
            if fractionalPart.count > 2 {
                return (text, false)
            }
        }

        rawText = updatedText
        return (updatedText, true)
    }
}
