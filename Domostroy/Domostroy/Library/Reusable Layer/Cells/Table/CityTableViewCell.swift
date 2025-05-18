//
//  CityTableViewCell.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 01.05.2025.
//

import UIKit
import SnapKit
import ReactiveDataDisplayManager

final class CityTableViewCell: UITableViewCell {

    typealias Model = ViewModel

    // MARK: - ViewModel

    struct ViewModel {
        let id: Int
        let title: String?
        let isSelected: Bool
        let selectionHandler: EmptyClosure
    }
}

// MARK: - ConfigurableItem

extension CityTableViewCell: ConfigurableItem {

    func configure(with viewModel: ViewModel) {
        var content = defaultContentConfiguration()
        content.text = viewModel.title
        accessoryType = viewModel.isSelected ? .checkmark : .none
        self.contentConfiguration = content
        tintColor = .Domostroy.primary
    }

}

// MARK: - Equatable

extension CityTableViewCell.ViewModel: Equatable {
    static func == (lhs: CityTableViewCell.ViewModel, rhs: CityTableViewCell.ViewModel) -> Bool {
        lhs.id == rhs.id && lhs.title == rhs.title && lhs.isSelected == rhs.isSelected
    }
}
