//
//  DButtonToggle.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 09.04.2025.
//

import UIKit

typealias ToggleAction = (Bool, _ handler: ((_ success: Bool) -> Void)?) -> Void

final class DToggleButton: DButton {

    // MARK: - Properties

    private var isOn: Bool = false
    private var onImage: UIImage?
    private var offImage: UIImage?
    private var toggleAction: ToggleAction?

    // MARK: - Configuration

    func configure(initialState: Bool, onImage: UIImage?, offImage: UIImage?, toggleAction: ToggleAction?) {
        self.onImage = onImage
        self.offImage = offImage
        self.toggleAction = toggleAction
        self.actionHandler = { [weak self] in
            guard let self else {
                return
            }
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            self.performToggleAction()
        }
        updateIcon()
    }

    // MARK: - Private methods

    private func performToggleAction() {
        setLoading(true)

        toggleAction?(isOn) { [weak self] success in
            self?.setLoading(false)
            if success {
                self?.isOn.toggle()
                self?.updateIcon()
            } else {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
        }
    }

    private func updateIcon() {
        image = isOn ? onImage : offImage
    }
}
