//
//  EditOfferPresenter.swift
//  Domostroy
//
//  Created by igorpustylnik on 15/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation
import ReactiveDataDisplayManager
import UIKit
import Kingfisher
import PhotosUI
import Combine
import NodeKit

final class EditOfferPresenter: NSObject, EditOfferModuleOutput {

    // MARK: - Constants

    private enum Constants {
        static let maxPicturesAmount = 5
    }

    // MARK: - EditOfferModuleOutput

    var onChooseFromLibrary: ((PHPickerViewControllerDelegate, Int) -> Void)?
    var onTakeAPhoto: ((UIImagePickerControllerDelegate & UINavigationControllerDelegate) -> Void)?
    var onCameraPermissionRequest: EmptyClosure?
    var onShowCities: ((CityEntity?) -> Void)?
    var onClose: EmptyClosure?
    var onChanged: EmptyClosure?
    var onSuccess: ((Int) -> Void)?

    // MARK: - Properties

    weak var view: EditOfferViewInput?

    private var offerId: Int?

    private let offerService: OfferService? = ServiceLocator.shared.resolve()
    private let categoryService: CategoryService? = ServiceLocator.shared.resolve()
    private let cityService: CityService? = ServiceLocator.shared.resolve()
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

    private var selectedCategoryId: Int?
    private var categoryPickerModel: PickerModel<CategoryEntity> = .init(all: [], selected: nil)

    private var selectedCityId: Int?
    private var selectedCity: CityEntity?

    private var price: PriceEntity?
}

// MARK: - EditOfferModuleInput

extension EditOfferPresenter: EditOfferModuleInput {

    func setOfferId(_ id: Int) {
        self.offerId = id
    }

    func setCity(_ city: CityEntity?) {
        self.selectedCity = city
        view?.setCity(title: selectedCity?.name ?? L10n.Localizable.Offers.Create.Button.City.placeholder)
    }
}

// MARK: - EditOfferViewOutput

extension EditOfferPresenter: EditOfferViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
        loadOffer { [weak self] in
            guard let self else {
                return
            }
            updateImages()
            updateCategoriesView()
            loadSelectedCategory { [weak self] in
                self?.loadCategories()
            }
            loadSelectedCity()
        }
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

    func showCities() {
        onShowCities?(selectedCity)
    }

    func deleteImage(uuid: UUID) {
        images.removeAll {
            $0.uuid == uuid
        }
        updateImages()
    }

    func priceChanged(_ text: String) {
        let priceValue = (try? Double(text, format: .number)) ?? 0
        price = .init(value: priceValue, currency: .rub)
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

    func save() {
        guard let selectedCity else {
            showCities()
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
        // TODO: Save
    }

    func delete() {
        guard let offerId else {
            return
        }
        view?.setDeletingActivity(isLoading: true)
        offerService?.deleteOffer(
            id: offerId
        ).sink(
            receiveCompletion: { [weak self] _ in
                self?.view?.setDeletingActivity(isLoading: false)
            },
            receiveValue: { [weak self] result in
                switch result {
                case .success:
                    self?.onChanged?()
                case .failure(let error):
                    DropsPresenter.shared.showError(error: error)
                }
            }
        ).store(in: &cancellables)
    }

    func close() {
        onClose?()
    }
}

// MARK: - Private methods

private extension EditOfferPresenter {

    func loadOffer(completion: EmptyClosure? = nil) {
        view?.setLoading(true)
        fetchOffer { [weak self] in
            self?.view?.setLoading(false)
            completion?()
        } handleResult: { [weak self] result in
            switch result {
            case .success(let offer):
                self?.view?.configure(
                    with: .init(
                        title: offer.title,
                        description: offer.description,
                        price: offer.price.value.stringDroppingTrailingZero
                    )
                )
                self?.title = offer.title
                self?.offerDescription = offer.description
                self?.price = offer.price
                // TODO: Add id to photos
                self?.images = offer.photos.map { .init(id: -1, image: nil, url: $0) }
                self?.selectedCategoryId = offer.categoryId
                self?.selectedCityId = offer.cityId
            case .failure(let error):
                DropsPresenter.shared.showError(error: error)
                self?.onClose?()
            }
        }

    }

    func fetchOffer(completion: EmptyClosure?, handleResult: ((NodeResult<OfferDetailsEntity>) -> Void)?) {
        guard let offerId else {
            completion?()
            return
        }
        offerService?.getOffer(
            id: offerId
        ).sink(
            receiveCompletion: { _ in completion?() },
            receiveValue: { handleResult?($0) }
        ).store(in: &cancellables)
    }

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

    func loadSelectedCategory(completion: EmptyClosure? = nil) {
        guard let selectedCategoryId else {
            completion?()
            return
        }
        categoryService?.getCategory(
            id: selectedCategoryId
        ).sink(
            receiveCompletion: { _ in completion?() },
            receiveValue: { [weak self] result in
                switch result {
                case .success(let category):
                    self?.categoryPickerModel.all.append(category)
                    self?.categoryPickerModel.selected = category
                case .failure(let error):
                    DropsPresenter.shared.showError(error: error)
                }
            }
        ).store(in: &cancellables)
    }

    func loadSelectedCity() {
        guard let selectedCityId else {
            return
        }
        cityService?.getCity(
            id: selectedCityId
        ).sink(
            receiveValue: { [weak self] result in
                switch result {
                case .success(let city):
                    self?.selectedCity = city
                    self?.view?.setCity(title: city.name)
                case .failure(let error):
                    DropsPresenter.shared.showError(error: error)
                }
            }
        ).store(in: &cancellables)
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

extension EditOfferPresenter: PHPickerViewControllerDelegate {

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

extension EditOfferPresenter: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
