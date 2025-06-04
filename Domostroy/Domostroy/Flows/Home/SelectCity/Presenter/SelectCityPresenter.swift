//
//  SelectCityPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 01/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import ReactiveDataDisplayManager
import Combine

final class SelectCityPresenter: SelectCityModuleOutput {

    // MARK: - SelectCityModuleOutput

    var onApply: ((CityEntity?) -> Void)?
    var onDismiss: EmptyClosure?

    // MARK: - Properties

    weak var view: SelectCityViewInput?

    private var cityService: CityService? = ServiceLocator.shared.resolve()
    private var cancellables: Set<AnyCancellable> = .init()

    private var allCities: [CityEntity] = []
    private var initialCity: CityEntity?
    private var selectedCity: CityEntity?
    private var allowAllCities = false
}

// MARK: - SelectCityModuleInput

extension SelectCityPresenter: SelectCityModuleInput {
    func setInitial(city: CityEntity?) {
        initialCity = city
        selectedCity = city
    }

    func setAllowAllCities(_ allow: Bool) {
        allowAllCities = allow
    }
}

// MARK: - SelectCityViewOutput

extension SelectCityPresenter: SelectCityViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
        search(query: nil)
    }

    func search(query: String?) {
        view?.setLoading(true)
        cityService?.getCities(
            query: query
        )
        .sink(
            receiveCompletion: { [weak self] _ in
                self?.view?.setLoading(false)
            },
            receiveValue: { [weak self] result in
                switch result {
                case .success(let cities):
                    self?.allCities = cities.cities
                    self?.updateView()
                case .failure(let error):
                    DropsPresenter.shared.showError(error: error)
                }
            }
        )
        .store(in: &cancellables)
    }

    func apply() {
        onApply?(selectedCity)
    }

    func dismiss() {
        onDismiss?()
    }

}

// MARK: - Private methods

private extension SelectCityPresenter {
    func makeViewModel(from model: CityEntity, isSelected: Bool) -> CityTableViewCell.ViewModel {
        .init(
            id: model.id,
            title: model.name,
            isSelected: isSelected) { [weak self] in
                self?.select(city: model)
        }
    }

    func select(city: CityEntity) {
        selectedCity = city
        updateView()
    }

    func updateView() {
        var items: [CityTableViewCell.ViewModel] = []
        if let initialCity, initialCity.id != -1 {
            items.append(makeViewModel(from: initialCity, isSelected: initialCity == selectedCity))
        }
        items.append(contentsOf: allCities
            .filter { $0 != initialCity }
            .map { makeViewModel(from: $0, isSelected: $0 == selectedCity) }
        )
        if allowAllCities {
            items.append(
                makeViewModel(
                    from: .init(id: -1, name: L10n.Localizable.SelectCity.allCities),
                    isSelected: selectedCity == nil || selectedCity?.id == -1
                )
            )
        }
        view?.setItems(with: items)
    }
}
