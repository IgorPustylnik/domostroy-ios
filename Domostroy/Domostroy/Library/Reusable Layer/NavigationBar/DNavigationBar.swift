//
//  DNavigationBar.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 04.04.2025.
//

import UIKit
import SnapKit

class DNavigationBar: UIView {

    // MARK: - Constants

    private enum Constants {
        static let vSpacing: CGFloat = 8
        static let mainBarHeight: CGFloat = 34
        static let buttonHSpacing: CGFloat = 5
    }

    // MARK: - UI Elements

    private lazy var blurView = UIVisualEffectView(effect: blurEffect)
    private lazy var blurEffect = UIBlurEffect(style: .systemMaterial)

    private var vStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.vSpacing
        $0.alignment = .center
        return $0
    }(UIStackView())

    private lazy var mainBar: UIView = {
        $0.addSubview(titleView)
        $0.addSubview(leftMainBarHStack)
        $0.addSubview(rightMainBarHStack)
        titleView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        leftMainBarHStack.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
        }
        rightMainBarHStack.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        return $0
    }(UIView())

    private lazy var leftMainBarHStack: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = Constants.buttonHSpacing
        return $0
    }(UIStackView())

    private lazy var titleView: UILabel = {
        $0.font = .systemFont(ofSize: 17, weight: .semibold)
        return $0
    }(UILabel())

    private lazy var rightMainBarHStack: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = Constants.buttonHSpacing
        return $0
    }(UIStackView())

    private var bottomLine: UIView = {
        $0.backgroundColor = .separator
        return $0
    }(UIView())

    // MARK: - Properties

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        let height = topInset + vStackView.frame.height + Constants.vSpacing
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }

    var title: String? {
        get { titleView.text }
        set { titleView.text = newValue }
    }

    var showsMainBar: Bool = true {
        didSet {
            if showsMainBar, !vStackView.arrangedSubviews.contains(mainBar) {
                vStackView.insertArrangedSubview(mainBar, at: 0)
                mainBar.snp.makeConstraints { make in
                    make.height.equalTo(Constants.mainBarHeight)
                    make.horizontalEdges.equalToSuperview()
                }
            } else if vStackView.arrangedSubviews.contains(mainBar) {
                mainBar.removeFromSuperview()
            }
        }
    }

    var leftItems: [UIView] = [] {
        didSet {
            leftMainBarHStack.arrangedSubviews.forEach { leftMainBarHStack.removeArrangedSubview($0) }
            leftItems.forEach { leftMainBarHStack.addArrangedSubview($0) }
        }
    }

    var rightItems: [UIView] = [] {
        didSet {
            rightMainBarHStack.arrangedSubviews.forEach { rightMainBarHStack.removeArrangedSubview($0) }
            rightItems.forEach { rightMainBarHStack.addArrangedSubview($0) }
        }
    }

    var topInset: CGFloat = 0 {
        didSet {
            topConstraint?.update(inset: topInset)
        }
    }
    private var topConstraint: Constraint?

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
        showsMainBar = true
        setScrollEdgeAppearance(progress: 0)

        addSubview(blurView)
        addSubview(vStackView)
        addSubview(bottomLine)

        vStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            topConstraint = make.top.equalToSuperview().inset(topInset).constraint
        }
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bottomLine.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(vStackView.snp.bottom).offset(Constants.vSpacing)
            make.height.equalTo(1 / UIScreen.main.scale)
        }

    }

    // MARK: - Public methods

    func addArrangedSubview(_ view: UIView) {
        vStackView.addArrangedSubview(view)
    }

    func removeArrangedSubview(_ view: UIView) {
        vStackView.removeArrangedSubview(view)
    }

    func setScrollEdgeAppearance(progress: Double) {
        blurView.alpha = progress
        bottomLine.alpha = progress
    }

    func addButtonToRight(image: UIImage, action: @escaping EmptyClosure) {
        rightItems.insert(createButton(image: image, action: action), at: 0)
    }

    func addButtonToLeft(image: UIImage, action: @escaping EmptyClosure) {
        leftItems.append(createButton(image: image, action: action))
    }

    func addToggleToRight(initialState: Bool, onImage: UIImage, offImage: UIImage, toggleAction: ToggleAction?) {
        rightItems.insert(
            createToggleButton(
                initialState: initialState,
                onImage: onImage,
                offImage: offImage,
                toggleAction: toggleAction
            ),
            at: 0
        )
    }

    func addToggleToLeft(initialState: Bool, onImage: UIImage, offImage: UIImage, toggleAction: ToggleAction?) {
        leftItems.append(
            createToggleButton(
                initialState: initialState,
                onImage: onImage,
                offImage: offImage,
                toggleAction: toggleAction
            )
        )
    }
}

// MARK: - Private methods

private extension DNavigationBar {

    func createButton(image: UIImage, action: @escaping EmptyClosure) -> DButton {
        let button = DButton(type: .plainPrimary)
        button.insets = .zero
        button.setAction {
            action()
        }
        button.image = image.withTintColor(.Domostroy.primary, renderingMode: .alwaysOriginal)
        return button
    }

    func createToggleButton(
        initialState: Bool,
        onImage: UIImage,
        offImage: UIImage,
        toggleAction: ToggleAction?
    ) -> DToggleButton {
        let button = DToggleButton(type: .plainPrimary)
        button.insets = .zero
        button.configure(
            initialState: initialState,
            onImage: onImage.withTintColor(.Domostroy.primary, renderingMode: .alwaysOriginal),
            offImage: offImage.withTintColor(.Domostroy.primary, renderingMode: .alwaysOriginal),
            toggleAction: toggleAction
        )
        return button
    }

}
