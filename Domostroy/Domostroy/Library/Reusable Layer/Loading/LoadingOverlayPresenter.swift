//
//  LoadingOverlayPresenter.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 25.05.2025.
//

import Foundation
import UIKit
import Combine

struct IdentifiableCancellable {
    let id: UUID
    let cancellable: AnyCancellable
}

final class LoadingOverlayPresenter {

    // MARK: - Properties

    static let shared = LoadingOverlayPresenter()

    private struct LoadingOverlayEntity {
        let id: UUID
        var title: String?
        var isVisible: Bool
    }

    private var overlayStack: [LoadingOverlayEntity] = []
    private var overlayView: DLoadingOverlayView?

    private init() {}

    // MARK: - Public methods

    func show(title: String? = nil) -> IdentifiableCancellable {
        let id = UUID()
        let cancellable = AnyCancellable { [weak self] in
            self?.hide(id: id)
        }

        DispatchQueue.main.async {
            self.overlayStack.append(.init(id: id, title: title, isVisible: true))
            self.updateOverlayAppearance()
        }

        return IdentifiableCancellable(id: id, cancellable: cancellable)
    }

    func hide(id: UUID) {
        DispatchQueue.main.async {
            if let index = self.overlayStack.firstIndex(where: { $0.id == id }) {
                self.overlayStack[index].isVisible = false
                self.overlayStack.remove(at: index)
                self.updateOverlayAppearance()
            }
        }
    }

    // MARK: - Private methods

    private func updateOverlayAppearance() {
        guard let top = overlayStack.last(where: { $0.isVisible }) else {
            hideOverlay()
            return
        }

        var isInitial = false

        if overlayView == nil {
            isInitial = true
            let view = DLoadingOverlayView()
            UIApplication.topWindow()?.addSubview(view)
            view.snp.makeConstraints { $0.edges.equalToSuperview() }
            overlayView = view
        }

        overlayView?.configure(title: top.title)
        if isInitial {
            overlayView?.show()
        }
    }

    private func hideOverlay() {
        guard let view = overlayView else {
            return
        }
        view.hide {
            view.removeFromSuperview()
            self.overlayView = nil
        }
    }
}
