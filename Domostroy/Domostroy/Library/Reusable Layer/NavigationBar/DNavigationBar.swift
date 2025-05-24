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
        static let mainBarSpacing: CGFloat = 10
        static let buttonHSpacing: CGFloat = 10
        static let horizontalInset: CGFloat = 16
    }

    // MARK: - UI Elements

    private lazy var blurView = UIVisualEffectView(effect: blurEffect)
    private lazy var blurEffect = UIBlurEffect(style: .systemMaterial)

    private var vStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.vSpacing
        return $0
    }(UIStackView())

    private(set) lazy var mainBar = {
        $0.addSubview(leftMainBarHStack)
        $0.addSubview(titleLabel)
        $0.addSubview(rightMainBarHStack)

        leftMainBarHStack.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview().priority(.low)
            make.leading.greaterThanOrEqualTo(leftMainBarHStack.snp.trailing).offset(Constants.mainBarSpacing)
            make.trailing.lessThanOrEqualTo(rightMainBarHStack.snp.leading).offset(-Constants.mainBarSpacing)
        }
        rightMainBarHStack.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalToSuperview()
        }
        return $0
    }(UIView())

    private lazy var leftMainBarHStack: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = Constants.buttonHSpacing
        return $0
    }(UIStackView())

    private lazy var titleLabel: UILabel = {
        $0.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
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

    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
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
    private var bottomConstraint: Constraint?

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
        clipsToBounds = true
        setScrollEdgeAppearance(progress: 0)

        addSubview(blurView)
        addSubview(vStackView)
        addSubview(bottomLine)

        vStackView.insertArrangedSubview(mainBar, at: 0)
        vStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(Constants.horizontalInset)
            topConstraint = make.top.equalToSuperview().inset(topInset).constraint
        }
        mainBar.snp.makeConstraints { make in
            make.height.equalTo(Constants.mainBarHeight)
            make.horizontalEdges.equalToSuperview()
        }
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bottomLine.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(vStackView.snp.bottom).offset(Constants.vSpacing)
            make.height.equalTo(1 / UIScreen.main.scale)
            bottomConstraint = make.bottom.equalToSuperview().constraint
        }
    }

    // MARK: - Public methods

    func addArrangedSubview(_ view: UIView) {
        vStackView.addArrangedSubview(view)
    }

    func insertArrangedSubview(_ view: UIView, at index: Int) {
        vStackView.insertArrangedSubview(view, at: index)
    }

    func removeArrangedSubview(_ view: UIView) {
        vStackView.removeArrangedSubview(view)
        view.removeFromSuperview()
    }

    func setScrollEdgeAppearance(progress: Double) {
        blurView.alpha = progress
        bottomLine.alpha = progress
    }

    func addButtonToRight(title: String?, image: UIImage?, action: @escaping EmptyClosure) {
        rightItems.insert(createButton(title: title, image: image, action: action), at: 0)
    }

    func addButtonToLeft(title: String?, image: UIImage?, action: @escaping EmptyClosure) {
        leftItems.append(createButton(title: title, image: image, action: action))
    }
}

// MARK: - Private methods

private extension DNavigationBar {

    func createButton(title: String?, image: UIImage?, action: @escaping EmptyClosure) -> DButton {
        let button = DButton(type: .plainPrimary)
        button.title = title
        button.insets = .zero
        button.setAction {
            action()
        }
        button.image = image?.withTintColor(.Domostroy.primary, renderingMode: .alwaysOriginal)
        return button
    }

}
