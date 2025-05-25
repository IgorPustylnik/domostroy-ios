//
//  DCheckmark.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 25.05.2025.
//

import UIKit
import SnapKit

protocol Checkmark: AnyObject {
    func setOn(_ newValue: Bool)
    var group: CheckmarkGroup? { get set }
}

final class DCheckmark: UIControl, Checkmark {

    // MARK: - Constants

    private enum Constants {
        static let mainHStackSpacing: CGFloat = 10
        static let highlightedAlpha: CGFloat = 0.7
        static let disabledAlpha: CGFloat = 0.5
        static let highlightedScale: CGFloat = 0.96
        static let checkboxSize: CGSize = .init(width: 24, height: 24)
        static let cornerRadius: CGFloat = 6
        static let disabledCheckboxColor: UIColor = .separator
        static let disabledCheckboxBorderWidth: CGFloat = 2
        static let touchesInset: UIEdgeInsets = .init(top: -10, left: -10, bottom: -10, right: -10)
        static let margins: UIEdgeInsets = .init(top: 5, left: 0, bottom: 5, right: 0)
        static let animationDuration: CGFloat = 0.3
        static let checkmarkImageSize: CGSize = .init(width: 16, height: 16)
    }

    // MARK: - UI Elements

    private lazy var mainHStackView = {
        $0.axis = .horizontal
        $0.spacing = Constants.mainHStackSpacing
        return $0
    }(UIStackView())

    private lazy var checkboxView = {
        return $0
    }(UIView())

    private lazy var disabledCheckboxView = {
        $0.layer.borderColor = Constants.disabledCheckboxColor.cgColor
        $0.layer.borderWidth = Constants.disabledCheckboxBorderWidth
        $0.layer.cornerRadius = Constants.cornerRadius
        $0.isUserInteractionEnabled = false
        return $0
    }(UIView())

    private lazy var enabledCheckboxView = {
        $0.backgroundColor = .Domostroy.primary
        $0.layer.cornerRadius = Constants.cornerRadius
        $0.layer.masksToBounds = true
        $0.isUserInteractionEnabled = false
        return $0
    }(UIView())

    private lazy var checkmarkImageView = {
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = false
        $0.image = .Buttons.checkmark.withTintColor(.white, renderingMode: .alwaysOriginal)
        return $0
    }(UIImageView())

    private lazy var label = {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        return $0
    }(UILabel())

    // MARK: - Properties

    private(set) var isOn: Bool = false {
        didSet {
            updateAppearance()
        }
    }

    private var highlightAnimator: UIViewPropertyAnimator?

    weak var group: CheckmarkGroup?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        trackTraitChanges()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    private func setupView() {
        addSubview(mainHStackView)
        mainHStackView.addArrangedSubview(checkboxView)
        mainHStackView.addArrangedSubview(label)
        checkboxView.addSubview(disabledCheckboxView)
        checkboxView.addSubview(enabledCheckboxView)
        checkboxView.addSubview(checkmarkImageView)

        mainHStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.margins)
        }
        checkboxView.snp.makeConstraints { make in
            make.size.equalTo(Constants.checkboxSize)
        }
        disabledCheckboxView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        enabledCheckboxView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        checkmarkImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(Constants.checkmarkImageSize)
        }

        updateAppearance()
    }

    private func updateAppearance() {
        disabledCheckboxView.isHidden = isOn
        enabledCheckboxView.isHidden = !isOn
        checkmarkImageView.isHidden = !isOn
    }

    private func trackTraitChanges() {
        registerForTraitChanges(
            [UITraitUserInterfaceStyle.self]
        ) { [weak self] (_: Self, _: UITraitCollection) in
            self?.updateCGColors()
        }
    }

    private func updateCGColors() {
        disabledCheckboxView.layer.borderColor = Constants.disabledCheckboxColor.cgColor
    }

    // MARK: - Configuration

    func setOn(_ newValue: Bool) {
        isOn = newValue
    }

    func setTitle(_ title: String) {
        label.text = title
    }

    // MARK: - Animation

    private func triggerHighlightAnimation(isEnding: Bool = false) {
        highlightAnimator?.stopAnimation(true)
        highlightAnimator = UIViewPropertyAnimator(
            duration: Constants.animationDuration,
            dampingRatio: 0.8
        ) {
            self.checkboxView.alpha = isEnding ? 1 : Constants.highlightedAlpha
            self.checkboxView.transform = isEnding ? .identity : CGAffineTransform(
                scaleX: Constants.highlightedScale,
                y: Constants.highlightedScale
            )
        }
        highlightAnimator?.startAnimation()
    }

    // MARK: - Touches overrides

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isHighlighted = true
        triggerHighlightAnimation()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)

        if !self.bounds.inset(by: Constants.touchesInset).contains(touchLocation) {
            isHighlighted = false
            triggerHighlightAnimation(isEnding: true)
        } else {
            isHighlighted = true
            triggerHighlightAnimation(isEnding: false)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isHighlighted = false
        triggerHighlightAnimation(isEnding: true)

        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        if self.bounds.inset(by: Constants.touchesInset).contains(touchLocation) {
            group?.toggle(checkmark: self)
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isHighlighted = false
        triggerHighlightAnimation(isEnding: true)
    }
}

// MARK: - Selectors

@objc
private extension DCheckmark {
    func handleTap() {
        group?.toggle(checkmark: self)
    }
}
