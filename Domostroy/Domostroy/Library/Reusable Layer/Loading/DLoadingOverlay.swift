//
//  DLoadingOverlay.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 25.05.2025.
//

import Foundation
import UIKit
import SnapKit
import Combine

struct IdentifiableCancellable {
    let id: UUID
    let cancellable: AnyCancellable
}

final class DLoadingOverlay: UIView {

    // MARK: - Singleton

    static let shared = DLoadingOverlay()

    // MARK: - Constants

    private enum Constants {
        static let containerMinSize: CGSize = .init(width: 80, height: 80)
        static let containerCornerRadius: CGFloat = 10
        static let containerInsets: CGFloat = 20
        static let margin: CGFloat = 30
        static let spacing: CGFloat = 20
        static let titleFont: UIFont = .systemFont(ofSize: 16, weight: .regular)
        static let backgroundColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ?
                .white.withAlphaComponent(0.1) : .black.withAlphaComponent(0.1)
        }
        static let containerMinimumStateTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    }

    // MARK: - UI Components

    private lazy var containerView: UIView = {
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = Constants.containerCornerRadius
        return $0
    }(UIView())

    private lazy var activityIndicator = {
        $0.tintColor = .label
        $0.isHidden = false
        return $0
    }(DLoadingIndicator(style: .large))

    private lazy var titleLabel: UILabel = {
        $0.font = Constants.titleFont
        $0.textColor = .label
        $0.textAlignment = .center
        return $0
    }(UILabel())

    // MARK: - Properties

    private struct LoadingOverlayEntity {
        let id: UUID
        var title: String?
        var isVisible: Bool
    }

    private var overlayStack: [LoadingOverlayEntity] = []

    // MARK: - Init

    private init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    private func setupUI() {
        alpha = 0
        backgroundColor = Constants.backgroundColor
        configureContainer()
        setupActivityIndicator()
        setupTitleLabel()
    }

    private func configureContainer() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(Constants.containerMinSize)
        }
    }

    private func setupActivityIndicator() {
        containerView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(containerView)
        }
    }

    private func setupTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(activityIndicator.snp.bottom).offset(Constants.spacing)
            make.horizontalEdges.bottom.equalTo(containerView).inset(Constants.containerInsets)
            make.height.equalTo(Constants.titleFont.lineHeight)
        }
    }

    private func updateContainerSize(for title: String?) {
        let targetView = UIApplication.topWindow()

        if let title = title {
            let maxLabelWidth = (
                targetView?.bounds.width ?? UIScreen.main.bounds.width - Constants.margin * 2
            ) - 2 * Constants.containerInsets
            let constraintRect = CGSize(width: maxLabelWidth, height: .greatestFiniteMagnitude)
            let boundingBox = title.boundingRect(
                with: constraintRect,
                options: .usesLineFragmentOrigin,
                attributes: [.font: Constants.titleFont],
                context: nil
            )

            let height = Constants.containerMinSize.height + Constants.spacing + boundingBox.height
            let width = max(
                height,
                min(
                    boundingBox.width + 2 * Constants.containerInsets,
                    (targetView?.bounds.width ?? UIScreen.main.bounds.width) - Constants.margin * 2
                )
            )

            containerView.snp.updateConstraints { make in
                make.size.equalTo(CGSize(width: width, height: height))
            }
            titleLabel.text = title
            titleLabel.isHidden = false
        } else {
            containerView.snp.updateConstraints { make in
                make.size.equalTo(Constants.containerMinSize)
            }
            titleLabel.isHidden = true
        }
    }

    private func updateOverlayAppearance() {
        guard let topOverlay = overlayStack.last(where: { $0.isVisible }) else {
            hide()
            return
        }

        updateContainerSize(for: topOverlay.title)

        if superview == nil {
            UIApplication.topWindow()?.addSubview(self)
            snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            show()
        }
    }

    // MARK: - Public methods

    func show(title: String? = nil) -> IdentifiableCancellable {
        let id = UUID()
        let cancellable = AnyCancellable { [weak self] in
            self?.hide(id: id)
        }
        DispatchQueue.main.async {
            self.overlayStack.append(.init(id: id, title: title, isVisible: true))
            self.activityIndicator.isHidden = false
            self.updateOverlayAppearance()
        }
        return IdentifiableCancellable(id: id, cancellable: cancellable)
    }

    func hide(id: UUID) {
        DispatchQueue.main.async {
            if let index = self.overlayStack.firstIndex(where: { $0.id == id }) {
                self.overlayStack[index].isVisible = false
                self.overlayStack.remove(at: index)
            }
            self.updateOverlayAppearance()
        }
    }

    // MARK: - Show / Hide Animations

    private func show() {
        containerView.transform = Constants.containerMinimumStateTransform
        alpha = 0

        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
            options: [.curveEaseOut, .allowUserInteraction]
        ) {
            self.alpha = 1
            self.containerView.transform = .identity
        }
    }

    private func hide() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [.curveEaseIn, .allowUserInteraction],
            animations: {
                self.alpha = 0
                self.containerView.transform = Constants.containerMinimumStateTransform
                self.activityIndicator.isHidden = true
            },
            completion: { _ in
                self.removeFromSuperview()
            }
        )
    }
}
