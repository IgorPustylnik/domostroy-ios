//
//  FilterPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 23/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation

struct Filters {
    var categoryFilter: PickerModel<Category>
}

final class FilterPresenter: FilterModuleOutput {

    // MARK: - FilterModuleOutput

    var onApply: ((Filters) -> Void)?
    var onDismiss: EmptyClosure?

    // MARK: - Properties

    weak var view: FilterViewInput?

    private var model: Filters?
}

// MARK: - FilterModuleInput

extension FilterPresenter: FilterModuleInput {
    func setFilters(_ model: Filters) {
        self.model = model
    }
}

// MARK: - FilterViewOutput

extension FilterPresenter: FilterViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
        guard let model else {
            return
        }
        updateCategoriesView()
        if model.categoryFilter.all.isEmpty {
            Task {
                await fetchCategories()
                DispatchQueue.main.async { [weak self] in
                    self?.updateCategoriesView()
                }
            }
        }
    }

    func selectCategory(index: Int) {
        guard
            let allCategories = model?.categoryFilter.all,
            index < allCategories.count + 1
        else {
            return
        }
        if index > 0 {
            model?.categoryFilter.selected = allCategories[index - 1]
        } else {
            model?.categoryFilter.selected = nil
        }
    }

    func apply() {
        guard let model else {
            return
        }
        onApply?(model)
        onDismiss?()
    }

    func dismiss() {
        onDismiss?()
    }

}

// MARK: - Private methods

private extension FilterPresenter {
    func fetchCategories() async {
        let categories = await _Temporary_Mock_NetworkService().fetchCategories()
        self.model?.categoryFilter.all = categories
    }

    func updateCategoriesView() {
        guard let model else {
            return
        }
        view?.setCategories(
            model.categoryFilter.all.map { $0.name },
            placeholder: L10n.Localizable.Filter.Placeholder.category,
            initialIndex: model.categoryFilter.all.firstIndex {
                $0 == model.categoryFilter.selected
            } ?? -1
        )
    }
}
