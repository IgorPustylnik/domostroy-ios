//
//  MainTabBarView.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit

final class MainTabBarView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let cornerRadius: CGFloat = 25
        static let internalCircleRadius: CGFloat = 40

        static let shadowColor: UIColor = UIColor.label.withAlphaComponent(0.25)
        static let shadowOpacity: Float = 0.25
        static let shadowRadius: CGFloat = 6
        static let shadowOffset: CGSize = .init(width: 0, height: -4)

        static let centerButtonImageSize: CGSize = .init(width: 32, height: 32)
        static let centerButtonSize: CGSize = .init(width: 56, height: 56)
        static let centerButtonOffsetY: CGFloat = -30

        static let buttonsHStackOffsetY: CGFloat = -14
        static let buttonsHStackInsetX: CGFloat = 12
    }

    // MARK: - UI Elements

    private lazy var centerButton: DButton = {
        $0.image = .MainTabBar.plus
        $0.imageSize = Constants.centerButtonImageSize
        $0.cornerRadius = Constants.centerButtonSize.width / 2
        $0.insets = .zero
        $0.snp.makeConstraints { make in
            make.size.equalTo(Constants.centerButtonSize)
        }
        $0.setAction { [weak self] in
            self?.didTapCenter?()
        }
        return $0
    }(DButton())

    private var blurView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))

    private lazy var buttonsHStackView: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())

    // MARK: - Properties

    var didSelect: ((Int) -> Void)?
    var didTapCenter: (() -> Void)?

    var isCenterControlEnabled: Bool = false {
        didSet {
            updateState()
        }
    }

    private var tabViews: [MainTabBarItemView] = []

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupUI()
        trackTraitChanges()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateState()
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if isHidden {
            return super.hitTest(point, with: event)
        }

        if !centerButton.isUserInteractionEnabled {
            return super.hitTest(point, with: event)
        }

        if centerButton.frame.contains(point) {
            return centerButton
        }

        return super.hitTest(point, with: event)
    }

    // MARK: - UI Setup

    private func setupUI() {
        addSubview(blurView)
        addSubview(centerButton)
        addSubview(buttonsHStackView)

        layer.shadowColor = Constants.shadowColor.cgColor
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowOffset = Constants.shadowOffset
        layer.shadowRadius = Constants.shadowRadius

        buttonsHStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().offset(Constants.buttonsHStackOffsetY)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(Constants.buttonsHStackInsetX)
        }

        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        centerButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(Constants.centerButtonOffsetY)
        }
    }

    private func trackTraitChanges() {
        registerForTraitChanges(
            [UITraitUserInterfaceStyle.self]
        ) { [weak self] (_: Self, _: UITraitCollection) in
            self?.updateCGColors()
        }
    }

    private func updateCGColors() {
        layer.shadowColor = Constants.shadowColor.cgColor
    }

    // MARK: - Public methods

    func setSelectedIndex(_ index: Int) {
        tabViews.enumerated().forEach { i, tabView in
            tabView.isSelected = (i == index)
        }
    }

    func configure(with tabs: [UITabBarItem]) {
        tabViews = tabs.map { MainTabBarItemView(tabBarItem: $0) }
        buttonsHStackView.arrangedSubviews.forEach { buttonsHStackView.removeArrangedSubview($0) }
        for i in 0..<tabs.count {
            buttonsHStackView.addArrangedSubview(tabViews[i])
            tabViews[i].didSelect = { [weak self] in
                self?.didSelect?(i)
            }
        }
    }
}

// MARK: - Private methods

private extension MainTabBarView {

    func updateState() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.systemBackground.cgColor
        shapeLayer.path = isCenterControlEnabled ? pathWithCutout() : pathWithoutCutout()
        blurView.layer.mask = shapeLayer
        centerButton.isHidden = !isCenterControlEnabled
        centerButton.isUserInteractionEnabled = isCenterControlEnabled
        tabViews[tabViews.count / 2].isEnabled = !isCenterControlEnabled
    }

    func pathWithCutout() -> CGPath {
        let path = UIBezierPath()

        let width = self.frame.width
        let height = self.frame.height

        let cornerRadius: CGFloat = Constants.cornerRadius
        let centerWidth = width / 2
        let circleRadius: CGFloat = Constants.internalCircleRadius
        let internalCornerRadius: CGFloat = circleRadius

        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        path.addArc(
            withCenter: CGPoint(x: cornerRadius, y: cornerRadius),
            radius: cornerRadius,
            startAngle: .pi,
            endAngle: .pi * 3 / 2,
            clockwise: true
        )
        path.addArc(
            withCenter: CGPoint(x: centerWidth - circleRadius - internalCornerRadius + 11.3, y: internalCornerRadius),
            radius: internalCornerRadius,
            startAngle: .pi * 3 / 2,
            endAngle: .pi,
            clockwise: true
        )
        path.addArc(
            withCenter: CGPoint(x: centerWidth, y: -1),
            radius: circleRadius,
            startAngle: .pi * 5 / 6,
            endAngle: .pi / 6,
            clockwise: false
        )
        path.addArc(
            withCenter: CGPoint(x: centerWidth + circleRadius + internalCornerRadius - 11.3, y: internalCornerRadius),
            radius: internalCornerRadius,
            startAngle: 0,
            endAngle: .pi * 3 / 2,
            clockwise: true
        )
        path.addArc(
            withCenter: CGPoint(x: width - cornerRadius, y: cornerRadius),
            radius: cornerRadius,
            startAngle: CGFloat.pi * 3 / 2,
            endAngle: 0,
            clockwise: true
        )
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()

        return path.cgPath
    }

    func pathWithoutCutout() -> CGPath {
        let path = UIBezierPath()

        let width = self.frame.width
        let height = self.frame.height
        let cornerRadius: CGFloat = Constants.cornerRadius

        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))

        path.addArc(
            withCenter: CGPoint(x: cornerRadius, y: cornerRadius),
            radius: cornerRadius,
            startAngle: .pi,
            endAngle: .pi * 3 / 2,
            clockwise: true
        )
        path.addArc(
            withCenter: CGPoint(x: width - cornerRadius, y: cornerRadius),
            radius: cornerRadius,
            startAngle: CGFloat.pi * 3 / 2,
            endAngle: 0,
            clockwise: true
        )

        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()

        return path.cgPath
    }

}
