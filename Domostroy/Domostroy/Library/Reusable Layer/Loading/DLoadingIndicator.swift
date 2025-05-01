//
//  DLoadingIndicator.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 01.05.2025.
//

import Foundation
import UIKit

final class DLoadingIndicator: UIView {

    // MARK: - Constants

    private enum Constants {
        static let size: CGSize = .init(width: 20, height: 20)
        static let lineWidthMultiplier: CGFloat = 0.1
        static let rotationSpeed: Double = 1
        static let defaultColor: UIColor = .label
    }

    // MARK: - UI Elements

    public let shapeLayer = CAShapeLayer()

    // MARK: - Properties

    override var intrinsicContentSize: CGSize {
        return self.sizeThatFits(UIView.layoutFittingExpandedSize)
    }

    override var isHidden: Bool {
        didSet {
            guard self.isHidden != oldValue else {
                return
            }

            if self.isHidden {
                self.shapeLayer.removeAllAnimations()
            } else {
                self.addSpinnerAnimation()
            }
        }
    }

    // swiftlint:disable implicitly_unwrapped_optional
    override var tintColor: UIColor! {
        didSet {
            handleTraitChanges()
        }
    }
    // swiftlint:enable implicitly_unwrapped_optional

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    private func setupUI() {
        shapeLayer.lineWidth = Constants.size.width * Constants.lineWidthMultiplier
        shapeLayer.strokeColor = tintColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0.75
        layer.addSublayer(shapeLayer)

        isHidden = true
        tintColor = Constants.defaultColor

        addSpinnerAnimation()

        registerForTraitChanges(
            [UITraitUserInterfaceStyle.self]
        ) { [weak self] (_: Self, _: UITraitCollection) in
            self?.handleTraitChanges()
        }
    }

    private func updateShapePath() {
        let radius = Constants.size.width / 2 - shapeLayer.lineWidth / 2
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        shapeLayer.path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: true
        ).cgPath
    }

    // MARK: - UIView overrides

    override func layoutSubviews() {
        super.layoutSubviews()

        shapeLayer.frame = bounds
        updateShapePath()

        if !isHidden {
            addSpinnerAnimation()
        }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let preferredSize = Constants.size
        return .init(
            width: min(preferredSize.width, size.width),
            height: min(preferredSize.height, size.height)
        )
    }

    // MARK: - Helpers

    private func addSpinnerAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.duration = Constants.rotationSpeed
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        shapeLayer.add(rotationAnimation, forKey: "rotationAnimation")
    }

    private func handleTraitChanges() {
        shapeLayer.strokeColor = tintColor.cgColor
    }
}
