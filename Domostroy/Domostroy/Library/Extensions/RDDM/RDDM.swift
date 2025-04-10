//
//  RDDM.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 09.04.2025.
//

// MARK: - Code that for some reason was not pulled from the RDDM sources thus could not be used unless added manually

import UIKit
import ReactiveDataDisplayManager

// MARK: - DiffableCollectionCellGenerator

open class DiffableCollectionCellGenerator<Cell: ConfigurableItem & UICollectionViewCell>:
    BaseCollectionCellGenerator<Cell>,
    IdOwner,
    DiffableItemSource where Cell.Model: Equatable {
    public let id: AnyHashable

    public var diffableItem: DiffableItem {
        .init(id: String(describing: id), state: AnyEquatable(model))
    }

    public init(uniqueId: AnyHashable, with model: Cell.Model, registerType: CellRegisterType = .nib) {
        self.id = uniqueId
        super.init(with: model, registerType: registerType)
    }

}

/// Protocol wrapper for object contains `id` property
public protocol IdOwner {
    var id: AnyHashable { get }
}

// MARK: - StaticDataDisplayWrapper

extension StaticDataDisplayWrapper where Base: UICollectionViewCell & ConfigurableItem, Base.Model: Equatable {

    public func diffableGenerator(
        uniqueId: AnyHashable,
        with model: Base.Model,
        and registerType: CellRegisterType = .nib
    ) -> DiffableCollectionCellGenerator<Base> {
        .init(uniqueId: uniqueId, with: model, registerType: registerType)
    }

}

extension StaticDataDisplayWrapper where Base: UICollectionViewCell & ConfigurableItem, Base.Model: Equatable & IdOwner {

    public func diffableGenerator(
        with model: Base.Model,
        and registerType: CellRegisterType = .nib
    ) -> DiffableCollectionCellGenerator<Base> {
        .init(uniqueId: model.id, with: model, registerType: registerType)
    }

}

public extension CollectionHeaderGenerator where Self: ViewBuilder {

    func registerHeader(in collectionView: UICollectionView) {
        collectionView.register(
            self.identifier,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: String(describing: self.identifier)
        )
    }

}

// MARK: - TitleCollectionHeaderGenerator

final class TitleCollectionHeaderGenerator {

    // MARK: - Private Properties

    private let title: String

    // MARK: - Initialization

    init(title: String) {
        self.title = title
    }
}

extension TitleCollectionHeaderGenerator: CollectionHeaderGenerator {

    var identifier: UICollectionReusableView.Type {
        TitleCollectionReusableView.self
    }

    func size(_ collectionView: UICollectionView, forSection section: Int) -> CGSize {
        let width = collectionView.bounds.width
        let height = TitleCollectionReusableView.getHeight(forWidth: width, with: title)
        return CGSize(width: width, height: height)
    }

}

// MARK: - ViewBuilder

extension TitleCollectionHeaderGenerator: ViewBuilder {

    func build(view: TitleCollectionReusableView) {
        view.configure(with: title)
    }

}

extension TitleCollectionHeaderGenerator: DiffableItemSource {

    var diffableItem: ReactiveDataDisplayManager.DiffableItem {
        DiffableItem(id: "title", state: .init(title))
    }

}
