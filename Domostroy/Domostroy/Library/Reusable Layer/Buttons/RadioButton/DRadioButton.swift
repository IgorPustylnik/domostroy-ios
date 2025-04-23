//
//  DRadioButton.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 21.04.2025.
//

import UIKit
import SnapKit

protocol RadioButton: AnyObject {
    func setOn(_ newValue: Bool)
    var group: RadioButtonGroup? { get set }
}

final class DRadioButton: UIControl, RadioButton {

    // MARK: - Constants

    private enum Constants {
        static let mainHStackSpacing: CGFloat = 10
        static let highlightedAlpha: CGFloat = 0.7
        static let disabledAlpha: CGFloat = 0.5
        static let highlightedScale: CGFloat = 0.96
        static let circleSize: CGSize = .init(width: 24, height: 24)
        static let innerCircleCoefficient: CGFloat = 0.4
        static let disabledCircleColor: UIColor = .separator
        static let disabledCircleBorderWidth: CGFloat = 2
        static let touchesInset: UIEdgeInsets = .init(top: -10, left: -10, bottom: -10, right: -10)
        static let margins: UIEdgeInsets = .init(top: 5, left: 0, bottom: 5, right: 0)
        static let animationDuration: CGFloat = 0.3
    }

    // MARK: - UI Elements

    private lazy var mainHStackView = {
        $0.axis = .horizontal
        $0.spacing = Constants.mainHStackSpacing
        return $0
    }(UIStackView())

    private lazy var circleView = {
        return $0
    }(UIView())

    private lazy var disabledCircleView = {
        $0.layer.borderColor = Constants.disabledCircleColor.cgColor
        $0.layer.borderWidth = Constants.disabledCircleBorderWidth
        $0.layer.cornerRadius = Constants.circleSize.width / 2
        $0.isUserInteractionEnabled = false
        return $0
    }(UIView())

    private lazy var enabledOuterCircleView = {
        $0.backgroundColor = .Domostroy.primary
        $0.layer.cornerRadius = Constants.circleSize.width / 2
        $0.layer.masksToBounds = true
        $0.isUserInteractionEnabled = false
        return $0
    }(UIView())

    private lazy var enabledInnerCircleView = {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = Constants.circleSize.width * Constants.innerCircleCoefficient / 2
        $0.layer.masksToBounds = true
        $0.isUserInteractionEnabled = false
        return $0
    }(UIView())

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

    weak var group: RadioButtonGroup?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    private func setupView() {
        addSubview(mainHStackView)
        mainHStackView.addArrangedSubview(circleView)
        mainHStackView.addArrangedSubview(label)
        circleView.addSubview(disabledCircleView)
        circleView.addSubview(enabledOuterCircleView)
        circleView.addSubview(enabledInnerCircleView)

        mainHStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.margins)
        }
        circleView.snp.makeConstraints { make in
            make.size.equalTo(Constants.circleSize)
        }
        disabledCircleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        enabledOuterCircleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        enabledInnerCircleView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(
                Constants.circleSize.width / 2 * (1 - Constants.innerCircleCoefficient)
            )
        }

        updateAppearance()
    }

    private func updateAppearance() {
        disabledCircleView.isHidden = isOn
        enabledOuterCircleView.isHidden = !isOn
        enabledInnerCircleView.isHidden = !isOn
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
            self.circleView.alpha = isEnding ? 1 : Constants.highlightedAlpha
            self.circleView.transform = isEnding ? .identity : CGAffineTransform(
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
            group?.select(button: self)
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
private extension DRadioButton {
    func handleTap() {
        group?.select(button: self)
    }
}
