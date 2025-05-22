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

    private(set) var isOn: Bool = false
    var onImage: UIImage?
    var offImage: UIImage?
    var onColor: UIColor?
    var offColor: UIColor?
    var onTitleColor: UIColor?
    var offTitleColor: UIColor?
    var onTitle: String?
    var offTitle: String?
    private var toggleAction: ToggleAction?

    // MARK: - Public methods

    func setOn(_ isOn: Bool) {
        self.isOn = isOn
        updateAppearance()
    }

    func setToggleAction(_ action: ToggleAction?) {
        toggleAction = action
        setAction { [weak self] in
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            self?.performToggleAction()
        }
    }

    func updateAppearance() {
        image = isOn ? onImage : offImage
        if let onColor, isOn {
            backgroundColor = onColor
        }
        if let offColor, !isOn {
            backgroundColor = offColor
        }
        titleLabel?.textColor = isOn ? onTitleColor : offTitleColor
        title = isOn ? onTitle : offTitle
    }

    // MARK: - Private methods

    private func performToggleAction() {
        setLoading(true)

        toggleAction?(!isOn) { [weak self] success in
            self?.setLoading(false)
            if success {
                self?.isOn.toggle()
                self?.updateAppearance()
            } else {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
        }
    }

}
