//
//  CreateOfferPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 15/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import ReactiveDataDisplayManager
import UIKit
import PhotosUI

struct CreateOfferDetails {
    let title: String
    let description: String
    let category: String
    let condition: String
    let price: Double
}

private struct ImageItem {
    let id = UUID()
    let image: UIImage
}

final class CreateOfferPresenter: NSObject, CreateOfferModuleOutput {

    // MARK: - Constants

    private enum Constants {
        static let maxPicturesAmount = 10
    }

    // MARK: - CreateOfferModuleOutput

    var onAddImages: ((PHPickerViewControllerDelegate, Int) -> Void)?
    var onShowCalendar: ((LessorCalendarConfig) -> Void)?
    var onClose: EmptyClosure?

    // MARK: - Properties

    weak var view: CreateOfferViewInput?

    var adapter: BaseCollectionManager?

    private var images: [ImageItem] = []
    private var visibleItems: Int {
        if images.count < Constants.maxPicturesAmount {
            return images.count + 1
        } else {
            return images.count
        }
    }

    private var categoryPickerModel: PickerModel<Category> = .init(all: [], selected: nil)
    private var conditionPickerModel: PickerModel<Condition> = .init(all: Condition.allCases, selected: nil)
    private var selectedDates: Set<Date> = Set()
}

// MARK: - CreateOfferModuleInput

extension CreateOfferPresenter: CreateOfferModuleInput {
    func setSelectedDates(_ dates: Set<Date>) {
        self.selectedDates = dates
        view?.setCalendarPlaceholder(active: selectedDates.isEmpty)
    }
}

// MARK: - CreateOfferViewOutput

extension CreateOfferPresenter: CreateOfferViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
        view?.updateImagesAmount(visibleItems)
        updateCategoriesView()
        loadCategories()
        loadConditions()
        refillAdapter()
    }

    func showCalendar() {
        let startDate = Date.now
        guard let endDate = Calendar.current.date(byAdding: .month, value: 6, to: startDate) else {
            return
        }
        let config = LessorCalendarConfig(
            dates: startDate...endDate,
            forbiddenDates: [],
            selectedDays: selectedDates
        )
        onShowCalendar?(config)
    }
    func create(details: CreateOfferDetails) {
        // TODO: Make request and use photos
    }

    func close() {
        onClose?()
    }

}

// MARK: - Private methods

private extension CreateOfferPresenter {

    func addImages() {
        let limit = Constants.maxPicturesAmount - images.count
        onAddImages?(self, limit)
    }

    func loadCategories() {
        Task {
            await fetchCategories()
            DispatchQueue.main.async { [weak self] in
                self?.updateCategoriesView()
            }
        }
    }

    func loadConditions() {
        view?.setConditions(
            conditionPickerModel.all.map { $0.description },
            placeholder: L10n.Localizable.Offers.Create.Placeholder.condition,
            initialIndex: conditionPickerModel.all.firstIndex {
                $0 == conditionPickerModel.selected
            } ?? -1
        )
    }

    func fetchCategories() async {
        let categories = await _Temporary_Mock_NetworkService().fetchCategories()
        self.categoryPickerModel.all = categories
    }

    func updateCategoriesView() {
        view?.setCategories(
            categoryPickerModel.all.map { $0.name },
            placeholder: L10n.Localizable.Offers.Create.Placeholder.category,
            initialIndex: categoryPickerModel.all.firstIndex {
                $0 == categoryPickerModel.selected
            } ?? -1
        )
    }
}

// MARK: - Generators

private extension CreateOfferPresenter {

    func makeImageGenerator(
        from imageItem: ImageItem
    ) -> BaseCollectionCellGenerator<AddingImageCollectionViewCell> {
        let viewModel = AddingImageCollectionViewCell.ViewModel(
            onDelete: { [weak self] in
                self?.deleteImage(id: imageItem.id)
            },
            image: imageItem.image)
        let generator = AddingImageCollectionViewCell.rddm.baseGenerator(with: viewModel, and: .class)
        return generator
    }

    func makeAddImageButtonGenerator() -> BaseCollectionCellGenerator<AddImageButtonCollectionViewCell> {
        let generator = AddImageButtonCollectionViewCell.rddm.baseGenerator(with: true, and: .class)
        generator.didSelectEvent += { [weak self] in
            self?.addImages()
        }
        return generator
    }

    func refillAdapter() {
        adapter?.clearCellGenerators()
        adapter?.addCellGenerators(images.map { makeImageGenerator(from: $0) })
        if images.count < Constants.maxPicturesAmount {
            adapter?.addCellGenerator(makeAddImageButtonGenerator())
        }
        adapter?.forceRefill()
    }

    func deleteImage(id: UUID) {
        images.removeAll { $0.id == id }
        refillAdapter()
        view?.updateImagesAmount(visibleItems)
    }

}

// MARK: - PHPickerViewControllerDelegate

extension CreateOfferPresenter: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        let group = DispatchGroup()

        for result in results {
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, _ in
                defer { group.leave() }
                guard let self, let image = reading as? UIImage else {
                    return
                }
                self.images.append(ImageItem(image: image))
            }
        }

        group.notify(queue: .main) {
            self.refillAdapter()
            self.view?.updateImagesAmount(self.visibleItems)
        }
    }
}
