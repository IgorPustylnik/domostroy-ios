//
//  DRadioButtonGroup.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 21.04.2025.
//

import UIKit

protocol RadioButtonGroup: AnyObject {
    func select(button: RadioButton)
}

final class DRadioButtonGroup<Value: Hashable>: RadioButtonGroup {

    // MARK: - Properties

    private var buttons: [Value: RadioButton] = [:]
    var selectedValue: Value?

    // MARK: - Public methods

    func add(button: RadioButton, value: Value) {
        buttons[value] = button
        button.group = self
    }

    func select(button: RadioButton) {
        for (v, b) in buttons {
            let shouldBeOn = (b === button)
            b.setOn(shouldBeOn)
            if shouldBeOn {
                selectedValue = v
            }
        }
    }
}
