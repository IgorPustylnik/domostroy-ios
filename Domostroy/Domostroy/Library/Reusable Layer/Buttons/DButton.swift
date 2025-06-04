//
//  DButton.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 04.04.2025.
//

import UIKit
import SnapKit

class DButton: UIButton {

    // MARK: - Constants

    private enum Constants {
        static let highlightedAlpha: CGFloat = 0.7
        static let disabledAlpha: CGFloat = 0.5
        static let hStackViewHighlightedScale: CGFloat = 0.98
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
        case filledPrimary, filledWhite, filledSecondary, plainPrimary, plain, modalPicker, navbar, destructive
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

    private lazy var _imageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
        $0.snp.makeConstraints { make in
            make.size.equalTo(imageSize)
        }
        return $0
    }(UIImageView())

    private var _titleLabel: UILabel = {
        $0.font = Constants.font
        $0.textAlignment = .center
        $0.isHidden = true
        return $0
    }(UILabel())

    private lazy var hStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = Constants.hSpacing
        $0.addArrangedSubview(_titleLabel)
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

    private var highlightAnimator: UIViewPropertyAnimator?

    var type: ButtonType

    var cornerRadius: CGFloat = Constants.defaultCornerRadius {
        didSet {
            backgroundView.layer.cornerRadius = cornerRadius
        }
    }

    var image: UIImage? {
        didSet {
            _imageView.image = image
            _imageView.isHidden = (image == nil)
        }
    }

    var imageSize: CGSize = Constants.defaultImageSize {
        didSet {
            _imageView.snp.remakeConstraints { make in
                make.size.equalTo(imageSize)
            }
        }
    }

    var imagePlacement: ImagePlacement = .left {
        didSet {
            updateImagePlacement()
        }
    }

    override var backgroundColor: UIColor? {
        get {
            backgroundView.backgroundColor
        }
        set {
            backgroundView.backgroundColor = newValue
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
                _titleLabel.isHidden = title.isEmpty
            } else {
                _titleLabel.isHidden = true
            }
            _titleLabel.text = title
        }
    }

    override var titleLabel: UILabel? {
        _titleLabel
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

    override var isHighlighted: Bool {
        didSet {
            triggerHighlightAnimation(isEnding: !isHighlighted)
        }
    }

    // MARK: - Configuration

    private func configure(_ type: DButton.ButtonType) {
        setupConstraints()
        switch type {
        case .filledPrimary:
            backgroundView.backgroundColor = .Domostroy.primary
            _titleLabel.textColor = .white
            activityIndicator.tintColor = .white
            tintColor = .white
        case .filledWhite:
            backgroundView.backgroundColor = .white
            _titleLabel.textColor = .Domostroy.primary
            activityIndicator.tintColor = .Domostroy.primary
            borderColor = .separator
        case .filledSecondary:
            backgroundView.backgroundColor = .secondarySystemBackground
            borderColor = .separator
            activityIndicator.tintColor = .label
        case .plainPrimary:
            backgroundView.backgroundColor = .clear
            _titleLabel.textColor = .Domostroy.primary
            activityIndicator.tintColor = .Domostroy.primary
        case .plain:
            backgroundView.backgroundColor = .clear
            _titleLabel.textColor = .label
            activityIndicator.tintColor = .label
        case .modalPicker:
            backgroundView.backgroundColor = .secondarySystemBackground
            _titleLabel.font = .systemFont(ofSize: 14, weight: .regular)
            _titleLabel.textColor = .label
            _titleLabel.textAlignment = .left
            borderColor = .separator
            activityIndicator.tintColor = .label
        case .navbar:
            _titleLabel.font = .systemFont(ofSize: 12, weight: .regular)
            backgroundView.backgroundColor = .systemBackground.withAlphaComponent(0.5)
            _titleLabel.textColor = .label
            hStackView.spacing = 12
            insets = .init(top: 8, left: 10, bottom: 8, right: 10)
            borderColor = .separator
            activityIndicator.tintColor = .label
        case .destructive:
            backgroundView.backgroundColor = .systemRed
            _titleLabel.textColor = .white
            activityIndicator.tintColor = .white
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

}

// MARK: - Action

extension DButton {

    func setAction(_ action: @escaping () -> Void) {
        addAction(
            .init(handler: { _ in
                action()
            }),
            for: .touchUpInside
        )
    }
}

// MARK: - Private methods

private extension DButton {

    func updateImagePlacement() {
        hStackView.removeArrangedSubview(_imageView)
        switch imagePlacement {
        case.left:
            hStackView.insertArrangedSubview(_imageView, at: 0)
        case .right:
            hStackView.insertArrangedSubview(_imageView, at: 1)
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
        backgroundView.layer.borderColor = borderColor.cgColor
    }
}

extension DButton: Loadable {
    func setLoading(_ isLoading: Bool) {
        isUserInteractionEnabled = !isLoading

        UIView.animate(withDuration: 0.1) {
            self._imageView.alpha = isLoading ? 0 : 1
            self._titleLabel.alpha = isLoading ? 0 : 1

            if isLoading {
                self.activityIndicator.isHidden = false
            } else {
                self.activityIndicator.isHidden = true
            }
        }
    }
}
