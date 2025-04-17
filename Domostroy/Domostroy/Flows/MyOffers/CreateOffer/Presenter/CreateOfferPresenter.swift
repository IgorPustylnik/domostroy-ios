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
}

// MARK: - CreateOfferModuleInput

extension CreateOfferPresenter: CreateOfferModuleInput {

}

// MARK: - CreateOfferViewOutput

extension CreateOfferPresenter: CreateOfferViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
        view?.updateImagesAmount(visibleItems)
        view?.setCategories([])
        loadCategories()
        view?.setConditions(Condition.allCases.map { $0.description })
        refillAdapter()
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
            let categories = await fetchCategories()
            DispatchQueue.main.async { [weak self] in
                self?.view?.setCategories(categories)
            }
        }
    }

    func fetchCategories() async -> [String] {
        // TODO: Network request
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        return ["Category1", "Category2"]
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
