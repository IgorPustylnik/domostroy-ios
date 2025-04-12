//
//  SearchFiltersView.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 12.04.2025.
//

import UIKit
import SnapKit

final class SearchSupplementaryView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let sortFiltersSpacing: CGFloat = 15
        static let imageSize: CGSize = .init(width: 18, height: 18)
    }

    // MARK: - UI Elements

    private lazy var locationButton = {
        $0.image = .Search.location.withTintColor(.label, renderingMode: .alwaysOriginal)
        $0.imageSize = Constants.imageSize
        // TODO: Remove
        $0.title = "Воронеж"
        $0.setAction { [weak self] in
            self?.onOpenLocation?()
        }
        return $0
    }(DButton(type: .navbar))

    private lazy var sortButton = {
        $0.image = .Search.sort.withTintColor(.label, renderingMode: .alwaysOriginal)
        $0.imageSize = Constants.imageSize
        // TODO: Remove
        $0.title = "По умолчанию"
        $0.setAction { [weak self] in
            self?.onOpenSort?()
        }
        return $0
    }(DButton(type: .navbar))

    private lazy var filtersButton = {
        $0.image = .Search.filter.withTintColor(.label, renderingMode: .alwaysOriginal)
        $0.imageSize = Constants.imageSize
        // TODO: Remove
        $0.title = "??"
        $0.setAction { [weak self] in
            self?.onOpenFilters?()
        }
        return $0
    }(DButton(type: .navbar))

    // MARK: - Properties

    var onOpenLocation: EmptyClosure?
    var onOpenSort: EmptyClosure?
    var onOpenFilters: EmptyClosure?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    private func setupUI() {
        addSubview(locationButton)
        addSubview(sortButton)
        addSubview(filtersButton)

        locationButton.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
        }
        filtersButton.snp.makeConstraints { make in
            make.trailing.verticalEdges.equalToSuperview()
        }
        sortButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.trailing.equalTo(filtersButton.snp.leading).offset(-Constants.sortFiltersSpacing)
        }
    }

}

// MARK: - Configuration

extension SearchSupplementaryView {

    func set(location: String) {
        locationButton.title = location
    }

    func set(sort: String) {
        sortButton.title = sort
    }

    // TODO: Implement a badge
    func set(filters: String) {
        filtersButton.title = filters
    }

}
