//
//  DButton.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 04.04.2025.
//

import UIKit
import SnapKit

final class DButton: UIControl {

    // MARK: - Constants

    private enum Constants {
        static let highlightedAlpha: CGFloat = 0.7
        static let disabledAlpha: CGFloat = 0.5
        static let hStackViewHighlightedScale: CGFloat = 0.96
        static let animationDuration: CGFloat = 0.3
        static let font: UIFont = .systemFont(ofSize: 17, weight: .semibold)
        static let touchesInset: UIEdgeInsets = .init(top: -30, left: -30, bottom: -30, right: -30)
        static let hSpacing: CGFloat = 5
        static let defaultCornerRadius: CGFloat = 14
        static let defaultImageSize: CGSize = .init(width: 24, height: 24)
        static let defaultInsets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
    }

    // MARK: - Enums

    enum ButtonType {
        case filledPrimary, filledWhite, plainPrimary, plain
    }

    enum ImagePlacement {
        case left, right
    }

    // MARK: - UI Elements

    private lazy var backgroundView: UIView = {
        $0.isUserInteractionEnabled = false
        return $0
    }(UIView())

    private lazy var imageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
        return $0
    }(UIImageView())

    private var titleLabel: UILabel = {
        $0.font = Constants.font
        $0.textAlignment = .center
        $0.isHidden = true
        return $0
    }(UILabel())

    private lazy var hStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = Constants.hSpacing
        $0.alignment = .center
        $0.addArrangedSubview(titleLabel)
        return $0
    }(UIStackView())

    // MARK: - Init

    init(type: DButton.ButtonType = .filledPrimary) {
        super.init(frame: .zero)
        configure(type)
        updateImagePlacement()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Properties

    private var actionHandler: (() -> Void)?
    private var highlightAnimator: UIViewPropertyAnimator?

    var cornerRadius: CGFloat = Constants.defaultCornerRadius {
        didSet {
            backgroundView.layer.cornerRadius = cornerRadius
        }
    }

    var image: UIImage? {
        didSet {
            imageView.image = image
            imageView.isHidden = (image == nil)
        }
    }

    var imageSize: CGSize {
        get {
            imageView.frame.size
        }
        set {
            imageView.snp.remakeConstraints { make in
                make.size.equalTo(newValue)
            }
            hStackView.spacing = newValue.width / 5
        }
    }

    var imagePlacement: ImagePlacement = .left {
        didSet {
            updateImagePlacement()
        }
    }

    var title: String? {
        didSet {
            if let title {
                titleLabel.isHidden = title.isEmpty
            } else {
                titleLabel.isHidden = true
            }
            titleLabel.text = title
        }
    }

    var insets: UIEdgeInsets = Constants.defaultInsets

    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1 : Constants.disabledAlpha
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        let height = max(
            titleLabel.frame.height, imageView.frame.height
        ) + insets.top + insets.bottom
        let width = max(
            backgroundView.frame.width,
            titleLabel.frame.width + Constants.hSpacing + imageView.frame.width + insets.left + insets.right)
        return CGSize(width: width, height: height)
    }

    // MARK: - Configuration

    private func configure(_ type: DButton.ButtonType) {
        switch type {
        case .filledPrimary:
            backgroundView.backgroundColor = .Domostroy.primary
            titleLabel.textColor = .white
        case .filledWhite:
            backgroundView.backgroundColor = .white
            titleLabel.textColor = .Domostroy.primary
        case .plainPrimary:
            backgroundView.backgroundColor = .clear
            titleLabel.textColor = .Domostroy.primary
        case .plain:
            backgroundView.backgroundColor = .clear
            titleLabel.textColor = .label
        }
        cornerRadius = Constants.defaultCornerRadius
        insertSubview(backgroundView, at: 0)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backgroundView.addSubview(hStackView)
        hStackView.snp.makeConstraints { make in
            make.center.equalTo(snp.center)
        }
        imageView.snp.makeConstraints { make in
            make.size.equalTo(Constants.defaultImageSize)
        }
    }

    // MARK: - Touches overriding

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
            actionHandler?()
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isHighlighted = false
        triggerHighlightAnimation(isEnding: true)
    }

}

// MARK: - Action

extension DButton {

    func setAction(_ action: @escaping () -> Void) {
        actionHandler = action
    }
}

// MARK: - Private methods

private extension DButton {

    func updateImagePlacement() {
        hStackView.removeArrangedSubview(imageView)
        switch imagePlacement {
        case.left:
            hStackView.insertArrangedSubview(imageView, at: 0)
        case .right:
            hStackView.insertArrangedSubview(imageView, at: 1)
        }
    }

    private func triggerHighlightAnimation(isEnding: Bool = false) {
        highlightAnimator?.stopAnimation(true)
        highlightAnimator = UIViewPropertyAnimator(
            duration: Constants.animationDuration,
            dampingRatio: 0.8
        ) {
            self.alpha = isEnding ? 1.0 : Constants.highlightedAlpha
            self.hStackView.transform = isEnding ? .identity : CGAffineTransform(
                scaleX: Constants.hStackViewHighlightedScale,
                y: Constants.hStackViewHighlightedScale
            )
        }
        highlightAnimator?.startAnimation()
    }

}
