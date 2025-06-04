//
//  TextFieldFormatter.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 17.05.2025.
//

import UIKit

protocol TextFieldFormatter: AnyObject {
    var rawText: String { get }
    func format(text: String) -> String
    func shouldChangeCharacters(
        in textField: UITextField,
        range: NSRange,
        replacementString string: String
    ) -> (newText: String, shouldChange: Bool)
}
