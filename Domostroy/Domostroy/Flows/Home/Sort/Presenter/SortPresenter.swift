//
//  SortPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 22/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

final class SortPresenter: SortModuleOutput {

    // MARK: - SortModuleOutput

    var onApply: ((Sort) -> Void)?
    var onDismiss: EmptyClosure?

    // MARK: - Properties

    private var sorts = Sort.allCases
    private var currentSort: Sort?

    weak var view: SortViewInput?
}

// MARK: - SortModuleInput

extension SortPresenter: SortModuleInput {
    func setup(initialSort: Sort) {
        currentSort = initialSort
    }
}

// MARK: - SortViewOutput

extension SortPresenter: SortViewOutput {

    func viewLoaded() {
        guard let currentSort else {
            return
        }
        view?.setup(with: sorts, initial: currentSort)
    }

    func apply(sort: Sort) {
        currentSort = sort
        onApply?(sort)
        onDismiss?()
    }

    func dismiss() {
        onDismiss?()
    }

}
