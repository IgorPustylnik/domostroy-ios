//
//  DCheckmarkGroup.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 25.05.2025.
//

import UIKit

protocol CheckmarkGroup: AnyObject {
    func toggle(checkmark: Checkmark)
}

final class DCheckmarkGroup<Value: Hashable>: CheckmarkGroup {

    // MARK: - Properties

    private var checkmarks: [Value: Checkmark] = [:]
    var selectedValues: Set<Value> = []
    var onDidToggle: ((Value, Bool) -> Void)?

    // MARK: - Public methods

    func add(checkmark: Checkmark, value: Value) {
        checkmarks[value] = checkmark
        checkmark.group = self
    }

    func toggle(checkmark: Checkmark) {
        for (v, c) in checkmarks {
            if c === checkmark {
                let newState = !selectedValues.contains(v)
                c.setOn(newState)

                if newState {
                    selectedValues.insert(v)
                } else {
                    selectedValues.remove(v)
                }

                onDidToggle?(v, newState)
                break
            }
        }
    }

    func setSelected(value: Value, isSelected: Bool) {
        guard let checkmark = checkmarks[value] else {
            return
        }

        checkmark.setOn(isSelected)

        if isSelected {
            selectedValues.insert(value)
        } else {
            selectedValues.remove(value)
        }
    }

    func selectAll() {
        for (value, checkmark) in checkmarks {
            checkmark.setOn(true)
            selectedValues.insert(value)
        }
    }

    func deselectAll() {
        for (value, checkmark) in checkmarks {
            checkmark.setOn(false)
            selectedValues.remove(value)
        }
    }
}
