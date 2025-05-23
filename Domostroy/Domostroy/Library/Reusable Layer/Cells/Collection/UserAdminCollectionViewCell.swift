//
//  UserAdminCollectionViewCell.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 21.05.2025.
//

import UIKit
import SnapKit
import ReactiveDataDisplayManager

final class UserAdminCollectionViewCell: UICollectionViewCell, HighlightableScaleView {

    var highlightScaleFactor: CGFloat = 0.97

    typealias Model = ViewModel

    // MARK: - ViewModel

    struct ViewModel {
        let id: Int
        let loadImage: LoadImageClosure
        let name: String
        let email: String
        let phoneNumber: String
        let registrationDate: String
        let offersAmount: String
        let isBanned: Bool
        let isAdmin: Bool
        let banAction: ToggleAction?
        let deleteAction: (_ handler: ((_ success: Bool) -> Void)?) -> Void?
    }

    // MARK: - Constants

    private enum Constants {
        static let mainHStackSpacing: CGFloat = 10
        static let rightVStackSpacing: CGFloat = 10
        static let infoVStackSpacing: CGFloat = 5
        static let avatarSize: CGSize = .init(width: 80, height: 80)
        static let buttonsHStackViewSpacing: CGFloat = 8
        static let buttonHeight: CGFloat = 32
        static let buttonCornerRadius: CGFloat = 10
    }

    // MARK: - UI Elements

    private lazy var mainHStackView = {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.spacing = Constants.mainHStackSpacing
        $0.addArrangedSubview(avatarImageView)
        $0.addArrangedSubview(rightVStackView)
        return $0
    }(UIStackView())

    private lazy var avatarImageView = {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = Constants.avatarSize.width / 2
        $0.layer.masksToBounds = true
        $0.backgroundColor = .secondarySystemBackground
        $0.snp.makeConstraints { make in
            make.size.equalTo(Constants.avatarSize)
        }
        return $0
    }(UIImageView())

    private lazy var rightVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.rightVStackSpacing
        $0.addArrangedSubview(infoVStackView)
        $0.addArrangedSubview(buttonsHStackView)
        return $0
    }(UIStackView())

    private lazy var infoVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.infoVStackSpacing
        $0.alignment = .fill
        $0.addArrangedSubview(nameLabel)
        $0.addArrangedSubview(emailLabel)
        $0.addArrangedSubview(phoneNumberLabel)
        $0.addArrangedSubview(registrationDateLabel)
        $0.addArrangedSubview(offersAmountLabel)
        return $0
    }(UIStackView())

    private lazy var nameLabel = {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 2
        return $0
    }(UILabel())

    private lazy var emailLabel = {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        return $0
    }(UILabel())

    private lazy var phoneNumberLabel = {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        return $0
    }(UILabel())

    private lazy var registrationDateLabel = {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        return $0
    }(UILabel())

    private lazy var offersAmountLabel = {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        return $0
    }(UILabel())

    private lazy var buttonsHStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = Constants.buttonsHStackViewSpacing
        $0.addArrangedSubview(banButton)
        $0.addArrangedSubview(deleteButton)
        return $0
    }(UIStackView())

    private lazy var banButton = {
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        $0.cornerRadius = Constants.buttonCornerRadius
        $0.onColor = UIColor { $0.userInterfaceStyle == .dark ? .secondarySystemBackground : .black }
        $0.offColor = .Domostroy.primary
        $0.onTitleColor = .white
        $0.offTitleColor = .white
        $0.onTitle = L10n.Localizable.AdminPanel.Users.Button.ban
        $0.offTitle = L10n.Localizable.AdminPanel.Users.Button.unban
        $0.snp.makeConstraints { make in
            make.height.equalTo(Constants.buttonHeight)
        }
        return $0
    }(DToggleButton())

    private lazy var deleteButton = {
        $0.backgroundColor = .systemRed
        $0.title = L10n.Localizable.AdminPanel.Users.Button.delete
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        $0.cornerRadius = Constants.buttonCornerRadius
        $0.snp.makeConstraints { make in
            make.height.equalTo(Constants.buttonHeight)
        }
        return $0
    }(DButton())

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        nameLabel.text = nil
        emailLabel.text = nil
        phoneNumberLabel.text = nil
        registrationDateLabel.text = nil
        offersAmountLabel.text = nil
        banButton.removeTarget(nil, action: nil, for: .allEvents)
        deleteButton.removeTarget(nil, action: nil, for: .allEvents)
        buttonsHStackView.isHidden = false
    }

    // MARK: - Setup UI

    private func setupUI() {
        backgroundColor = .systemBackground
        addSubview(mainHStackView)
        mainHStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().priority(.high)
        }
    }
}

// MARK: - ConfigurableItem

extension UserAdminCollectionViewCell: ConfigurableItem {
    func configure(with viewModel: ViewModel) {
        viewModel.loadImage(avatarImageView) {}
        nameLabel.text = viewModel.name
        emailLabel.text = viewModel.email
        phoneNumberLabel.text = viewModel.phoneNumber
        registrationDateLabel.text = viewModel.registrationDate
        offersAmountLabel.text = viewModel.offersAmount
        if !viewModel.isAdmin {
            banButton.setToggleAction(viewModel.banAction)
            banButton.setOn(!viewModel.isBanned)
            deleteButton.setAction { [weak self] in
                self?.deleteButton.setLoading(true)
                viewModel.deleteAction { success in
                    self?.deleteButton.setLoading(false)
                }
            }
        } else {
            buttonsHStackView.isHidden = true
        }
    }
}

// MARK: - Equatable ViewModel

extension UserAdminCollectionViewCell.ViewModel: Equatable {
    static func ==(lhs: UserAdminCollectionViewCell.ViewModel, rhs: UserAdminCollectionViewCell.ViewModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.email == rhs.email &&
        lhs.phoneNumber == rhs.phoneNumber &&
        lhs.registrationDate == rhs.registrationDate &&
        lhs.offersAmount == rhs.offersAmount
    }
}
