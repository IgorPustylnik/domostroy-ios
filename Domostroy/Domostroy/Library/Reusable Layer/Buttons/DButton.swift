//
//  DButton.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 04.04.2025.
//

import UIKit
import SnapKit

class DButton: UIControl {

    // MARK: - Constants

    private enum Constants {
        static let highlightedAlpha: CGFloat = 0.7
        static let disabledAlpha: CGFloat = 0.5
        static let hStackViewHighlightedScale: CGFloat = 0.96
        static let font: UIFont = .systemFont(ofSize: 17, weight: .semibold)
        static let touchesInset: UIEdgeInsets = .init(top: -30, left: -30, bottom: -30, right: -30)
        static let hSpacing: CGFloat = 5
        static let borderWidth: CGFloat = 1
        static let defaultCornerRadius: CGFloat = 14
        static let defaultImageSize: CGSize = .init(width: 24, height: 24)
        static let defaultInsets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
    }

    // MARK: - Enums

    enum ButtonType {
        case filledPrimary, filledWhite, filledSecondary, plainPrimary, plain, calendar, navbar, destructive
    }

    enum ImagePlacement {
        case left, right
    }

    // MARK: - UI Elements

    private lazy var backgroundView: UIView = {
        $0.isUserInteractionEnabled = false
        $0.layer.cornerRadius = cornerRadius
        return $0
    }(UIView())

    private lazy var imageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
        $0.snp.makeConstraints { make in
            make.size.equalTo(imageSize)
        }
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
        $0.addArrangedSubview(titleLabel)
        return $0
    }(UIStackView())

    private lazy var activityIndicator = DLoadingIndicator()

    // MARK: - Init

    init(type: DButton.ButtonType = .filledPrimary) {
        self.type = type
        super.init(frame: .zero)
        configure(type)
        updateImagePlacement()
        trackTraitChanges()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Properties

    var actionHandler: (() -> Void)?
    private var highlightAnimator: UIViewPropertyAnimator?

    var type: ButtonType

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

    var imageSize: CGSize = Constants.defaultImageSize {
        didSet {
            imageView.snp.remakeConstraints { make in
                make.size.equalTo(imageSize)
            }
        }
    }

    var imagePlacement: ImagePlacement = .left {
        didSet {
            updateImagePlacement()
        }
    }

    var borderColor: UIColor = .clear {
        didSet {
            backgroundView.layer.borderColor = borderColor.cgColor
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

    var insets: UIEdgeInsets = Constants.defaultInsets {
        didSet {
            hStackView.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.edges.equalToSuperview().inset(insets).priority(.medium)
            }
        }
    }

    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1 : Constants.disabledAlpha
        }
    }

    // swiftlint:disable implicitly_unwrapped_optional
    override var tintColor: UIColor! {
        didSet {
            activityIndicator.tintColor = tintColor
        }
    }
    // swiftlint:enable implicitly_unwrapped_optional

    // MARK: - Configuration

    private func configure(_ type: DButton.ButtonType) {
        setupConstraints()
        switch type {
        case .filledPrimary:
            backgroundView.backgroundColor = .Domostroy.primary
            titleLabel.textColor = .white
            tintColor = .white
        case .filledWhite:
            backgroundView.backgroundColor = .white
            titleLabel.textColor = .Domostroy.primary
            tintColor = .Domostroy.primary
        case .filledSecondary:
            backgroundView.backgroundColor = .secondarySystemBackground
            borderColor = .separator
            tintColor = .label
        case .plainPrimary:
            backgroundView.backgroundColor = .clear
            titleLabel.textColor = .Domostroy.primary
            tintColor = .Domostroy.primary
        case .plain:
            backgroundView.backgroundColor = .clear
            titleLabel.textColor = .label
            tintColor = .label
        case .calendar:
            backgroundView.backgroundColor = .secondarySystemBackground
            titleLabel.font = .systemFont(ofSize: 14, weight: .regular)
            titleLabel.textColor = .label
            titleLabel.textAlignment = .left
            borderColor = .separator
            tintColor = .label
        case .navbar:
            titleLabel.font = .systemFont(ofSize: 12, weight: .regular)
            backgroundView.backgroundColor = .systemBackground.withAlphaComponent(0.5)
            titleLabel.textColor = .label
            hStackView.spacing = 12
            insets = .init(top: 8, left: 10, bottom: 8, right: 10)
            borderColor = .separator
            tintColor = .label
        case .destructive:
            backgroundView.backgroundColor = .systemRed
            titleLabel.textColor = .white
            tintColor = .white
        }
    }

    private func setupConstraints() {
        insertSubview(backgroundView, at: 0)
        backgroundView.layer.borderWidth = Constants.borderWidth
        backgroundView.layer.borderColor = borderColor.cgColor
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backgroundView.addSubview(hStackView)
        hStackView.snp.makeConstraints { make in
            make.center.equalTo(snp.center)
            make.edges.equalToSuperview().inset(insets).priority(.medium)
        }
        backgroundView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
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
            duration: 0.3,
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

    private func trackTraitChanges() {
        registerForTraitChanges(
            [UITraitUserInterfaceStyle.self]
        ) { [weak self] (_: Self, _: UITraitCollection) in
            self?.updateCGColors()
        }
    }

    private func updateCGColors() {
        switch type {
        case .navbar:
            backgroundView.layer.borderColor = borderColor.cgColor
        default:
            break
        }
    }
}

extension DButton: Loadable {
    func setLoading(_ isLoading: Bool) {
        isUserInteractionEnabled = !isLoading

        UIView.animate(withDuration: 0.1) {
            self.imageView.alpha = isLoading ? 0 : 1
            self.titleLabel.alpha = isLoading ? 0 : 1

            if isLoading {
                self.activityIndicator.isHidden = false
            } else {
                self.activityIndicator.isHidden = true
            }
        }
    }
}
