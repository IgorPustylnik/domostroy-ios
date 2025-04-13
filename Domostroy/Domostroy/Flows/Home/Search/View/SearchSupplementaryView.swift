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
        static let mainHStackSpacing: CGFloat = 10
        static let rightHStackSpacing: CGFloat = 10
        static let imageSize: CGSize = .init(width: 18, height: 18)
    }

    // MARK: - UI Elements

    private lazy var mainHStackView = {
        $0.axis = .horizontal
        $0.addArrangedSubview(cityButton)
        $0.addArrangedSubview(spacer)
        $0.addArrangedSubview(rightHStackView)
        return $0
    }(UIStackView())

    private lazy var cityButton = {
        $0.image = .Search.location.withTintColor(.label, renderingMode: .alwaysOriginal)
        $0.imageSize = Constants.imageSize
        $0.setAction { [weak self] in
            self?.onOpenCity?()
        }
        return $0
    }(DButton(type: .navbar))

    private lazy var spacer = {
        $0.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(Constants.mainHStackSpacing)
        }
        return $0
    }(UIView())

    private lazy var rightHStackView = {
        $0.axis = .horizontal
        $0.spacing = Constants.rightHStackSpacing
        $0.addArrangedSubview(sortButton)
        $0.addArrangedSubview(filtersButton)
        return $0
    }(UIStackView())

    private lazy var sortButton = {
        $0.image = .Search.sort.withTintColor(.label, renderingMode: .alwaysOriginal)
        $0.imageSize = Constants.imageSize
        $0.setAction { [weak self] in
            self?.onOpenSort?()
        }
        return $0
    }(DButton(type: .navbar))

    private lazy var filtersButton = {
        $0.image = .Search.filter
        $0.imageSize = Constants.imageSize
        $0.setAction { [weak self] in
            self?.onOpenFilters?()
        }
        return $0
    }(DButton(type: .navbar))

    // MARK: - Properties

    var onOpenCity: EmptyClosure?
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
        addSubview(mainHStackView)
        mainHStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

// MARK: - Configuration

extension SearchSupplementaryView {

    func set(city: String) {
        cityButton.title = city
    }

    func set(sort: String) {
        sortButton.title = sort
    }

    func set(hasFilters: Bool) {
        filtersButton.image = hasFilters ? .Search.filterEnabled : .Search.filter
    }

}
