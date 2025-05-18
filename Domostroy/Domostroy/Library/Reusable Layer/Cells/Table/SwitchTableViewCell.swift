//
//  SwitchTableViewCell.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 18.05.2025.
//

import UIKit
import SnapKit
import ReactiveDataDisplayManager

final class SwitchTableViewCell: UITableViewCell {

    // MARK: - Constants

    private enum Constants {
        static let insets: UIEdgeInsets = .init(top: 7, left: 16, bottom: 7, right: 16)
        static let mainVStackSpacing: CGFloat = 16
        static let iconContainerCornerRadius: CGFloat = 7
        static let iconSize: CGSize = .init(width: 22, height: 22)
    }

    // MARK: - ViewModel

    typealias Model = ViewModel

    struct ViewModel {
        let initialState: Bool
        let color: UIColor
        let image: UIImage?
        let title: String
        let toggleAction: ToggleAction?
    }

    // MARK: - UI Elements

    private lazy var mainHStackView = {
        $0.axis = .horizontal
        $0.spacing = Constants.mainVStackSpacing
        $0.addArrangedSubview(iconContainerView)
        $0.addArrangedSubview(titleLabel)
        $0.addArrangedSubview(toggleSwitch)
        return $0
    }(UIStackView())

    private lazy var iconContainerView = {
        $0.layer.cornerRadius = Constants.iconContainerCornerRadius
        $0.layer.masksToBounds = true
        return $0
    }(UIView())

    private lazy var iconImageView = {
        $0.snp.makeConstraints { make in
            make.size.equalTo(Constants.iconSize)
        }
        return $0
    }(UIImageView())

    private lazy var titleLabel = {
        $0.font = .systemFont(ofSize: 17, weight: .regular)
        return $0
    }(UILabel())

    private lazy var toggleSwitch = UISwitch()

    private lazy var spinner = DLoadingIndicator()

    // MARK: - Properties

    private var switchHandler: ToggleAction?

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        toggleSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    private func setupUI() {
        contentView.addSubview(mainHStackView)
        iconContainerView.addSubview(iconImageView)
        iconContainerView.snp.makeConstraints { make in
            make.width.equalTo(iconContainerView.snp.height)
        }
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        mainHStackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(Constants.insets)
        }
        selectionStyle = .none
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        iconImageView.backgroundColor = nil
        titleLabel.text = nil
        switchHandler = nil
        toggleSwitch.setOn(false, animated: false)
    }

}

// MARK: - ConfigurableItem

extension SwitchTableViewCell: ConfigurableItem {

    func configure(with viewModel: ViewModel) {
        iconImageView.image = viewModel.image?.withTintColor(.white, renderingMode: .alwaysOriginal)
        iconContainerView.backgroundColor = viewModel.color
        titleLabel.text = viewModel.title
        toggleSwitch.setOn(viewModel.initialState, animated: false)
        switchHandler = viewModel.toggleAction
    }

}

// MARK: - Selectors

@objc
private extension SwitchTableViewCell {
    func switchChanged() {
        switchHandler?(toggleSwitch.isOn) { [weak self] success in
            guard let self, !success else {
                return
            }
            toggleSwitch.setOn(!toggleSwitch.isOn, animated: true)
        }
    }
}

// MARK: - Equatable

extension SwitchTableViewCell.ViewModel: Equatable {
    static func == (lhs: SwitchTableViewCell.ViewModel, rhs: SwitchTableViewCell.ViewModel) -> Bool {
        lhs.color == rhs.color && lhs.image == rhs.image && lhs.title == rhs.title
    }
}
