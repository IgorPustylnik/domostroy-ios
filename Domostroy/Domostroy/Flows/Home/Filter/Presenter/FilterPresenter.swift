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
    var priceFilter: (from: PriceEntity?, to: PriceEntity?)

    var isNotEmpty: Bool {
        categoryFilter.selected != nil
        || priceFilter.from != nil
        || priceFilter.to != nil
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
        view?.setPriceFilter(
            from: model.priceFilter.from?.value.stringDroppingTrailingZero ?? "",
            to: model.priceFilter.to?.value.stringDroppingTrailingZero ?? ""
        )
    }
}

// MARK: - FilterViewOutput

extension FilterPresenter: FilterViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
        updateCategoriesView()
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

    func setPriceFrom(_ from: String) {
        guard let price = try? Double(from, format: .number) else {
            model?.priceFilter.from = nil
            return
        }
        model?.priceFilter.from = PriceEntity(value: price, currency: .rub)
    }

    func setPriceTo(_ to: String) {
        guard let price = try? Double(to, format: .number) else {
            model?.priceFilter.to = nil
            return
        }
        model?.priceFilter.to = PriceEntity(value: price, currency: .rub)
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
