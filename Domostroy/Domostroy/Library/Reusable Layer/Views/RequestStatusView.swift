//
//  RequestStatusView.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 12.05.2025.
//

import UIKit
import SnapKit

final class RequestStatusView: UIView {

    // MARK: - ViewModel

    enum Status {
        case accepted(Date?)
        case pending
        case declined(Date?)

        var title: String {
            switch self {
            case .accepted(let date):
                return "\(L10n.Localizable.RequestDetails.Status.acceptedOn) \(date?.toDMMYY() ?? "")"
            case .pending:
                return L10n.Localizable.RequestDetails.Status.pending
            case .declined(let date):
                return "\(L10n.Localizable.RequestDetails.Status.declinedOn) \(date?.toDMMYY() ?? "")"
            }
        }

        var backgroundColor: UIColor {
            switch self {
            case .accepted:
                return .Domostroy.primary.withAlphaComponent(0.5)
            case .pending:
                return .systemYellow.withAlphaComponent(0.5)
            case .declined:
                return .systemRed.withAlphaComponent(0.5)
            }
        }

        var borderColor: UIColor {
            switch self {
            case .accepted:
                return .Domostroy.primary
            case .pending:
                return .systemYellow
            case .declined:
                return .systemRed
            }
        }

        var image: UIImage {
            switch self {
            case .accepted:
                return .Status.checkmarkOutline.withTintColor(.label, renderingMode: .alwaysOriginal)
            case .pending:
                return .Status.clockOutline.withTintColor(.label, renderingMode: .alwaysOriginal)
            case .declined:
                return .Status.xmarkOutline.withTintColor(.label, renderingMode: .alwaysOriginal)
            }
        }
    }

    // MARK: - Constants

    private enum Constants {
        static let insets: UIEdgeInsets = .init(top: 8, left: 16, bottom: 8, right: 16)
        static let cornerRadius: CGFloat = 14
        static let borderWidth: CGFloat = 1
        static let imageSize: CGSize = .init(width: 20, height: 20)
        static let mainHStackSpacing: CGFloat = 10
    }

    // MARK: - UI Elements

    private lazy var backgroundView = {
        $0.layer.cornerRadius = Constants.cornerRadius
        $0.layer.borderWidth = Constants.borderWidth
        $0.layer.masksToBounds = true
        return $0
    }(UIView())

    private lazy var mainHStackView = {
        $0.axis = .horizontal
        $0.spacing = Constants.mainHStackSpacing
        $0.addArrangedSubview(imageView)
        $0.addArrangedSubview(titleLabel)
        return $0
    }(UIStackView())

    private lazy var imageView = {
        $0.snp.makeConstraints { make in
            make.size.equalTo(Constants.imageSize)
        }
        return $0
    }(UIImageView())

    private lazy var titleLabel = {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .label
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

    private func setupUI () {
        addSubview(backgroundView)
        backgroundView.addSubview(mainHStackView)

        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mainHStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.insets)
        }
    }

    // MARK: - Configuration

    func configure(with status: Status) {
        imageView.image = status.image
        titleLabel.text = status.title
        backgroundView.backgroundColor = status.backgroundColor
        backgroundView.layer.borderColor = status.borderColor.cgColor
    }

}
