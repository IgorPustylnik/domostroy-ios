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
import Combine

struct ImageItem {
    let uuid = UUID()
    let id: Int
    var image: UIImage?
    let url: URL?
}

final class CreateOfferPresenter: NSObject, CreateOfferModuleOutput {

    // MARK: - Constants

    private enum Constants {
        static let maxPicturesAmount = 5
    }

    // MARK: - CreateOfferModuleOutput

    var onChooseFromLibrary: ((PHPickerViewControllerDelegate, Int) -> Void)?
    var onTakeAPhoto: ((UIImagePickerControllerDelegate & UINavigationControllerDelegate) -> Void)?
    var onCameraPermissionRequest: EmptyClosure?
    var onShowCities: ((CityEntity?) -> Void)?
    var onShowCalendar: ((LessorCalendarConfig) -> Void)?
    var onClose: EmptyClosure?
    var onSuccess: ((Int) -> Void)?

    // MARK: - Properties

    weak var view: CreateOfferViewInput?

    private let offerService: OfferService? = ServiceLocator.shared.resolve()
    private let categoryService: CategoryService? = ServiceLocator.shared.resolve()
    private var cancellables: [AnyCancellable] = []

    private var images: [ImageItem] = []
    private var visibleItems: Int {
        if images.count < Constants.maxPicturesAmount {
            return images.count + 1
        } else {
            return images.count
        }
    }

    private var title: String?
    private var offerDescription: String?
    private var categoryPickerModel: PickerModel<CategoryEntity> = .init(all: [], selected: nil)
    private var selectedCity: CityEntity?
    private var selectedDates: Set<Date> = Set()
    private var price: PriceEntity?
}

// MARK: - CreateOfferModuleInput

extension CreateOfferPresenter: CreateOfferModuleInput {
    func setSelectedDates(_ dates: Set<Date>) {
        self.selectedDates = dates
        view?.setCalendarPlaceholder(active: selectedDates.isEmpty)
    }

    func setCity(_ city: CityEntity?) {
        self.selectedCity = city
        view?.setCity(title: selectedCity?.name ?? L10n.Localizable.Offers.Create.Button.City.placeholder)
    }
}

// MARK: - CreateOfferViewOutput

extension CreateOfferPresenter: CreateOfferViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
        updateImages()
        updateCategoriesView()
        loadCategories()
    }

    func titleChanged(_ text: String) {
        self.title = text
    }

    func descriptionChanged(_ text: String) {
        self.offerDescription = text
    }

    func setSelectedCategory(index: Int) {
        guard index < categoryPickerModel.all.count else {
            return
        }
        categoryPickerModel.selected = categoryPickerModel.all[index]
    }

    func chooseFromLibrary() {
        let limit = Constants.maxPicturesAmount - images.count
        onChooseFromLibrary?(self, limit)
    }

    func takeAPhoto() {
        if PermissionHelper.shared.checkCameraAccess() {
            onTakeAPhoto?(self)
        } else {
            PermissionHelper.shared.requestCameraAccess { [weak self] success in
                guard let self else {
                    return
                }
                if success {
                    onTakeAPhoto?(self)
                } else {
                    onCameraPermissionRequest?()
                }
            }
        }
    }

    func deleteImage(uuid: UUID) {
        images.removeAll {
            $0.uuid == uuid
        }
        updateImages()
    }

    func showCities() {
        onShowCities?(selectedCity)
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

    func priceChanged(_ text: String) {
        let priceValue = (try? Double(text, format: .number)) ?? 0
        price = .init(value: priceValue, currency: .rub)
    }

    func create() {
        guard let selectedCity else {
            showCities()
            return
        }
        guard !selectedDates.isEmpty else {
            showCalendar()
            return
        }
        guard !images.isEmpty else {
            chooseFromLibrary()
            return
        }
        guard let category = categoryPickerModel.selected,
              let title,
              let offerDescription,
              let category = categoryPickerModel.selected,
              let price else {
            DropsPresenter.shared.showError(title: L10n.Localizable.ValidationError.someRequiredMissing)
            return
        }

        view?.setActivity(isLoading: true)
        offerService?.createOffer(
            createOfferEntity: .init(
                title: title,
                description: offerDescription,
                categoryId: category.id,
                price: price,
                cityId: selectedCity.id,
                rentDates: selectedDates,
                photos: images.compactMap { $0.image }
            )
        )
        .sink(
            receiveCompletion: { [weak self] _ in
                self?.view?.setActivity(isLoading: false)
            },
            receiveValue: { [weak self] result in
                switch result {
                case .success(let offerIdEntity):
                    self?.onClose?()
                    self?.onSuccess?(offerIdEntity.offerId)
                case .failure(let error):
                    DropsPresenter.shared.showError(
                        title: L10n.Localizable.Offers.Create.Error.failed,
                        error: error
                    )
                }
            }
        )
        .store(in: &cancellables)
    }

    func close() {
        onClose?()
    }

}

// MARK: - Private methods

private extension CreateOfferPresenter {

    func loadCategories() {
        categoryService?.getCategories(
        )
        .sink(receiveValue: { [weak self] result in
            switch result {
            case .success(let categories):
                self?.categoryPickerModel.all = categories.categories
                self?.updateCategoriesView()
            case .failure(let error):
                DropsPresenter.shared.showError(error: error)
            }
        })
        .store(in: &cancellables)
    }

    func updateImages() {
        let viewModels = images.map { makeImageViewModel(imageItem: $0) }
        view?.setImages(
            viewModels,
            canAddMore: images.count < Constants.maxPicturesAmount
        )
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

    func makeImageViewModel(imageItem: ImageItem) -> AddingImageCollectionViewCell.Model {
        .init(
            onDelete: { [weak self] in
                self?.deleteImage(uuid: imageItem.uuid)
            },
            url: imageItem.url,
            loadImage: { imageView in
                if let image = imageItem.image {
                    imageView.image = image
                } else {
                    DispatchQueue.main.async {
                        imageView.kf.setImage(with: imageItem.url)
                    }
                }
            }
        )
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
                self.images.append(ImageItem(id: -1, image: image, url: nil))
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self else {
                return
            }
            updateImages()
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension CreateOfferPresenter: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        picker.dismiss(animated: true)

        if let image = info[.originalImage] as? UIImage {
            images.append(.init(id: -1, image: image, url: nil))
            updateImages()
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
