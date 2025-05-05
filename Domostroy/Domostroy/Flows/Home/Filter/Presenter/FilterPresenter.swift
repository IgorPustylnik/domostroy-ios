//
//  FilterPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 23/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation
import Combine

struct FiltersViewModel {
    var categoryFilter: PickerModel<CategoryEntity>

    var isNotEmpty: Bool {
        categoryFilter.selected != nil
    }
}

final class FilterPresenter: FilterModuleOutput {

    // MARK: - FilterModuleOutput

    var onApply: ((FiltersViewModel) -> Void)?
    var onDismiss: EmptyClosure?

    // MARK: - Properties

    weak var view: FilterViewInput?

    private var categoryService: CategoryService? = ServiceLocator.shared.resolve()
    private var cancellables: Set<AnyCancellable> = .init()

    private var model: FiltersViewModel?
}

// MARK: - FilterModuleInput

extension FilterPresenter: FilterModuleInput {
    func setFilters(_ model: FiltersViewModel) {
        self.model = model
    }
}

// MARK: - FilterViewOutput

extension FilterPresenter: FilterViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
        fetchCategories()
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
    func fetchCategories() {
        categoryService?.getCategories(
        )
        .sink(receiveCompletion: { [weak self] _ in
            self?.updateCategoriesView()
        }, receiveValue: { [weak self] result in
            switch result {
            case .success(let categories):
                self?.model?.categoryFilter.all = categories.categories
            case .failure(let error):
                DropsPresenter.shared.showError(error: error)
            }
        })
        .store(in: &cancellables)
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
