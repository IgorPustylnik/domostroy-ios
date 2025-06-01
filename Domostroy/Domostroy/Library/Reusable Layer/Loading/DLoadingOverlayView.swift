//
//  DLoadingOverlayView.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 01.06.2025.
//

import UIKit
import SnapKit

final class DLoadingOverlayView: UIView {

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

    // MARK: - UI Elements

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
        alpha = 0
        backgroundColor = Constants.backgroundColor

        addSubview(containerView)
        containerView.addSubview(activityIndicator)
        containerView.addSubview(titleLabel)

        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(Constants.containerMinSize)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(activityIndicator.snp.bottom).offset(Constants.spacing)
            $0.horizontalEdges.bottom.equalToSuperview().inset(Constants.containerInsets)
            $0.height.equalTo(Constants.titleFont.lineHeight).priority(.low)
        }
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    // MARK: - Public

    func configure(title: String?) {
        let maxLabelWidth = (UIScreen.main.bounds.width - Constants.margin * 2) - 2 * Constants.containerInsets
        let constraintRect = CGSize(width: maxLabelWidth, height: .greatestFiniteMagnitude)

        if let title = title {
            let boundingBox = title.boundingRect(
                with: constraintRect,
                options: .usesLineFragmentOrigin,
                attributes: [.font: Constants.titleFont],
                context: nil
            )
            let height = Constants.containerMinSize.height + Constants.spacing + boundingBox.height
            let width = max(
                height, min(
                    boundingBox.width + 2 * Constants.containerInsets, UIScreen.main.bounds.width - Constants.margin * 2
                )
            )

            containerView.snp.updateConstraints {
                $0.size.equalTo(CGSize(width: width, height: height))
            }
            titleLabel.text = title
            titleLabel.isHidden = false
        } else {
            containerView.snp.updateConstraints {
                $0.size.equalTo(Constants.containerMinSize)
            }
            titleLabel.isHidden = true
        }
    }

    func show(animated: Bool = true) {
        containerView.transform = Constants.containerMinimumStateTransform
        alpha = 0

        UIView.animate(withDuration: animated ? 0.3 : 0,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.5,
                       options: [.curveEaseOut, .allowUserInteraction]) {
            self.alpha = 1
            self.containerView.transform = .identity
        }
    }

    func hide(animated: Bool = true, completion: @escaping () -> Void) {
        UIView.animate(withDuration: animated ? 0.3 : 0,
                       delay: 0,
                       options: [.curveEaseIn, .allowUserInteraction],
                       animations: {
            self.alpha = 0
            self.containerView.transform = Constants.containerMinimumStateTransform
        }, completion: { _ in
            completion()
        })
    }
}
