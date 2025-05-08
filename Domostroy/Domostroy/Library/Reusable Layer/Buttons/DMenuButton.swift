//
//  DMenuButton.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 10.05.2025.
//

import UIKit

final class DMenuButton: DButton {

    // MARK: - Properties

    var onSelect: ((Int) -> Void)?

    var titles: [String] = [] {
        didSet {
            updateMenu()
        }
    }

    var selectedIndex: Int = 0 {
        didSet {
            guard selectedIndex < titles.count else {
                return
            }
            self.title = titles[selectedIndex]
            updateMenu()
        }
    }

    // MARK: - Init

    override init(type: DButton.ButtonType = .filledPrimary) {
        super.init(type: type)
        showsMenuAsPrimaryAction = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func updateMenu() {
        let actions = titles.enumerated().map { index, title in
            UIAction(
                title: title,
                state: index == selectedIndex ? .on : .off
            ) { [weak self] _ in
                self?.selectedIndex = index
                self?.onSelect?(index)
            }
        }
        menu = UIMenu(options: .singleSelection, children: actions)
    }
}
