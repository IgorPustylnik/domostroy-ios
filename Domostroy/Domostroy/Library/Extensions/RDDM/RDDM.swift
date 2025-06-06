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

// swiftlint:disable line_length
extension StaticDataDisplayWrapper where Base: UICollectionViewCell & ConfigurableItem, Base.Model: Equatable & IdOwner {
// swiftlint:enable line_length

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

    private let id = UUID().uuidString
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
        DiffableItem(id: id, state: .init(title))
    }

}

class ContextMenuCollectionCellGenerator<Cell: ConfigurableItem>: SelectableItem where Cell: UICollectionViewCell {

    // MARK: - Public Properties

    public var isNeedDeselect = true
    public var didSelectEvent = BaseEvent<Void>()
    public var didDeselectEvent = BaseEvent<Void>()
    public let model: Cell.Model
    public let menu: UIMenu?

    private var fakeButton: UIButton?

    // MARK: - Initialization

    public init(with model: Cell.Model, menu: UIMenu?) {
        self.model = model
        self.menu = menu
    }

    // MARK: - Public methods

    public func configure(cell: Cell, with model: Cell.Model) {
        cell.configure(with: model)
    }

    public func triggerMenu() {
        let gestureRecognizer = fakeButton?.gestureRecognizers?.first {
            $0.description.contains("UITouchDownGestureRecognizer")
        }
        gestureRecognizer?.touchesBegan([], with: UIEvent())
        gestureRecognizer?.touchesEnded([], with: UIEvent())
    }

}

extension ContextMenuCollectionCellGenerator: CollectionCellGenerator {
    public var identifier: String {
        return String(describing: Cell.self)
    }

    public func generate(collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: identifier,
            for: indexPath
        ) as? Cell else {
            return UICollectionViewCell()
        }
        configure(cell: cell, with: model)
        if let menu {
            let button = UIButton()
            button.menu = menu
            button.showsMenuAsPrimaryAction = true
            button.alpha = 0
            button.isUserInteractionEnabled = false
            cell.contentView.addSubview(button)
            button.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

            fakeButton = button
        }
        return cell
    }

    public func registerCell(in collectionView: UICollectionView) {
        collectionView.register(Cell.self, forCellWithReuseIdentifier: identifier)
    }
}
