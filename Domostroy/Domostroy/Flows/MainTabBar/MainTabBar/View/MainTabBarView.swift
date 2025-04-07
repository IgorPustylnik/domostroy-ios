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

    // MARK: - UI Elements

    private lazy var centerButton: DButton = {
        $0.image = .MainTabBar.plus
        $0.imageSize = .init(width: 32, height: 32)
        $0.cornerRadius = 28
        $0.setAction { [weak self] in
            self?.didTapCenter?()
        }
        return $0
    }(DButton())

    private var blurView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))

    private lazy var buttonsHStackView: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
        return $0
    }(UIStackView())

    // MARK: - Properties

    var didSelect: ((Int) -> Void)?
    var didTapCenter: (() -> Void)?

    var isCenterButtonEnabled: Bool = false {
        didSet {
            updateState()
        }
    }

    private var tabViews: [MainTabBarItemView] = []

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupUI()
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

        layer.shadowColor = UIColor.label.withAlphaComponent(0.25).cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: -4)
        layer.shadowRadius = 6

        buttonsHStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().offset(-14)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
        }

        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        centerButton.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.width.equalTo(56)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(-30)
        }
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
        shapeLayer.path = isCenterButtonEnabled ? pathWithCutout() : pathWithoutCutout()
        blurView.layer.mask = shapeLayer
        centerButton.isHidden = !isCenterButtonEnabled
        centerButton.isUserInteractionEnabled = isCenterButtonEnabled
        tabViews[tabViews.count / 2].isEnabled = !isCenterButtonEnabled
    }

    func pathWithCutout() -> CGPath {
        let path = UIBezierPath()

        let width = self.frame.width
        let height = self.frame.height

        let cornerRadius: CGFloat = 25
        let centerWidth = width / 2
        let circleRadius: CGFloat = 40
        let internalCornerRadius: CGFloat = 40

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
        let cornerRadius: CGFloat = 25

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
