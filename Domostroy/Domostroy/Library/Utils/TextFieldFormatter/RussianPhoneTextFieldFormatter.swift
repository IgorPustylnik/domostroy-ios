//
//  RussianPhoneTextFieldFormatter.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 17.05.2025.
//

import Foundation
import UIKit

final class RussianPhoneTextFieldFormatter: TextFieldFormatter {

    // MARK: - Properties

    private(set) var rawText: String = ""

    // MARK: - TextFieldFormatter

    func format(text: String) -> String {
        let filteredText = text.filter { $0.isNumber }
        rawText = filteredText
        return Self.format(phoneNumber: text.filter { $0.isNumber })
    }

    func shouldChangeCharacters(
        in textField: UITextField,
        range: NSRange,
        replacementString string: String
    ) -> (newText: String, shouldChange: Bool) {
        guard let currentText = textField.text else {
            return (string, true)
        }

        if string.isEmpty && range.length > 0 {
            if range.length > 1 {
                var digitsToDelete = 0
                let rangeEnd = range.location + range.length

                for i in range.location..<rangeEnd {
                    if i < currentText.count {
                        let charIndex = currentText.index(currentText.startIndex, offsetBy: i)
                        if currentText[charIndex].isNumber {
                            digitsToDelete += 1
                        }
                    }
                }

                let firstDigitOffset = getDigitOffset(in: currentText, for: range)

                if firstDigitOffset < rawText.count {
                    let startIndex = rawText.index(rawText.startIndex, offsetBy: firstDigitOffset)
                    let endIndex = rawText.index(startIndex, offsetBy: min(digitsToDelete, rawText.count - firstDigitOffset))
                    rawText.removeSubrange(startIndex..<endIndex)
                }

                let formattedText = Self.format(phoneNumber: rawText)

                DispatchQueue.main.async {
                    self.setCursorPosition(in: textField, deletePosition: range.location)
                }

                return (formattedText, false)
            } else {
                let deletePosition = range.location

                if deletePosition < currentText.count {
                    let index = currentText.index(currentText.startIndex, offsetBy: deletePosition)
                    if !currentText[index].isNumber {
                        var newPosition = deletePosition
                        while newPosition > 0 {
                            newPosition -= 1
                            let charIndex = currentText.index(currentText.startIndex, offsetBy: newPosition)
                            if currentText[charIndex].isNumber {
                                let digitRange = NSRange(location: newPosition, length: 1)
                                return shouldChangeCharacters(in: textField, range: digitRange, replacementString: "")
                            }
                        }
                    }
                }
            }
        }

        rawText = currentText.filter { $0.isNumber }

        let cursorOffset = getDigitOffset(in: currentText, for: range)
        let nsRange = NSRange(location: cursorOffset, length: range.length)

        if let swiftRange = Range(nsRange, in: rawText) {
            rawText.replaceSubrange(swiftRange, with: string.filter { $0.isNumber })
        }

        rawText = String(rawText.prefix(11))

        let formattedText = Self.format(phoneNumber: rawText)

        if string.isEmpty && range.length > 0 {
            DispatchQueue.main.async {
                self.setCursorPosition(in: textField, deletePosition: range.location)
            }
        }

        return (formattedText, false)
    }

    // MARK: - Private methods

    private func setCursorPosition(in textField: UITextField, deletePosition: Int) {
        guard let text = textField.text else {
            return
        }

        var newPosition = min(deletePosition, text.count)

        if newPosition < text.count {
            let charIndex = text.index(text.startIndex, offsetBy: newPosition)
            if !text[charIndex].isNumber && !text[charIndex].isLetter {
                while newPosition < text.count {
                    let nextIndex = text.index(text.startIndex, offsetBy: newPosition)
                    if text[nextIndex].isNumber {
                        break
                    }
                    newPosition += 1
                }

                if newPosition >= text.count {
                    newPosition = deletePosition
                    while newPosition > 0 {
                        newPosition -= 1
                        let prevIndex = text.index(text.startIndex, offsetBy: newPosition)
                        if text[prevIndex].isNumber {
                            newPosition += 1
                            break
                        }
                    }
                }
            }
        }

        guard let cursorPosition = textField.position(from: textField.beginningOfDocument, offset: newPosition) else {
            return
        }
        textField.selectedTextRange = textField.textRange(from: cursorPosition, to: cursorPosition)
    }

    private func getDigitOffset(in text: String, for range: NSRange) -> Int {
        var digitIndex = 0
        for (i, char) in text.enumerated() {
            if i >= range.location {
                break
            }
            if char.isNumber {
                digitIndex += 1
            }
        }
        return digitIndex
    }

    // MARK: - Static phone formatting

    static func format(phoneNumber: String) -> String {
        var number = phoneNumber.filter { $0.isNumber }
        if number.hasPrefix("8") {
            number = "7" + number.dropFirst()
        } else if !number.hasPrefix("7") && !number.isEmpty {
            number = "7" + number
        }
        number = String(number.prefix(11))

        switch number.count {
        case 0:
            return ""
        case 1...1:
            return "+7"
        case 2...3:
            let code = number.dropFirst()
            return "+7 (\(code)"
        case 4...6:
            let code = number.dropFirst().prefix(3)
            let part = number.dropFirst(4)
            return "+7 (\(code)) \(part)"
        case 7...8:
            let code = number.dropFirst().prefix(3)
            let part1 = number.dropFirst(4).prefix(3)
            let part2 = number.dropFirst(7)
            return "+7 (\(code)) \(part1)-\(part2)"
        default:
            let code = number.dropFirst().prefix(3)
            let part1 = number.dropFirst(4).prefix(3)
            let part2 = number.dropFirst(7).prefix(2)
            let part3 = number.dropFirst(9)
            return "+7 (\(code)) \(part1)-\(part2)-\(part3)"
        }
    }
}
