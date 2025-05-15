//
//  MyOfferDetailsView.swift
//  Domostroy
//
//  Created by igorpustylnik on 15/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit

final class MyOfferDetailsView: UIView {

    // MARK: - ViewModel

    struct ViewModel {
        let price: String
        let title: String
        let loadCity: (UILabel) -> Void
        let loadInfo: (@escaping ([(String, String)]) -> Void) -> Void
        let description: String
        let onCalendar: EmptyClosure?
    }

    // MARK: - Constants

    private enum Constants {
        static let mainVStackSpacing: CGFloat = 20
        static let topVStackSpacing: CGFloat = 10
        static let headerVStackSpacing: CGFloat = 5
        static let stackHeaderBottomPadding: CGFloat = 10
        static let infoDetailsVStackSpacing: CGFloat = 3
    }

    // MARK: - Properties

    private var onCalendar: EmptyClosure?

    // MARK: - UI Elements

    private lazy var mainVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.mainVStackSpacing
        $0.addArrangedSubview(headerVStackView)
        $0.addArrangedSubview(calendarVStackView)
        $0.addArrangedSubview(infoVStackView)
        $0.addArrangedSubview(descriptionVStackView)
        return $0
    }(UIStackView())

    // MARK: - Header

    private lazy var headerVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.topVStackSpacing
        $0.addArrangedSubview(titleVStackView)
        $0.addArrangedSubview(cityLabel)
        return $0
    }(UIStackView())

    private lazy var titleVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.headerVStackSpacing
        $0.addArrangedSubview(priceLabel)
        $0.addArrangedSubview(titleLabel)
        return $0
    }(UIStackView())

    private lazy var priceLabel = {
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        return $0
    }(UILabel())

    private lazy var titleLabel = {
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private lazy var cityLabel = {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    // MARK: - Calendar

    private lazy var calendarVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.stackHeaderBottomPadding
        $0.addArrangedSubview(calendarHeaderLabel)
        $0.addArrangedSubview(calendarButton)
        return $0
    }(UIStackView())

    private lazy var calendarHeaderLabel = {
        $0.text = L10n.Localizable.OfferDetails.My.Calendar.header
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private lazy var calendarButton = {
        $0.image = .Buttons.calendar.withTintColor(.label, renderingMode: .alwaysOriginal)
        $0.imagePlacement = .right
        $0.title = L10n.Localizable.OfferDetails.My.Calendar.placeholder
        $0.setAction { [weak self] in
            self?.onCalendar?()
        }
        return $0
    }(DButton(type: .modalPicker))

    // MARK: - Info

    private lazy var infoVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.stackHeaderBottomPadding
        $0.addArrangedSubview(infoHeaderLabel)
        $0.addArrangedSubview(infoDetailsVStackView)
        return $0
    }(UIStackView())

    private lazy var infoHeaderLabel = {
        $0.text = L10n.Localizable.OfferDetails.Info.header
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private lazy var infoDetailsVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.infoDetailsVStackSpacing
        return $0
    }(UIStackView())

    // MARK: - Description

    private lazy var descriptionVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.stackHeaderBottomPadding
        $0.addArrangedSubview(descriptionHeaderLabel)
        $0.addArrangedSubview(descriptionLabel)
        return $0
    }(UIStackView())

    private lazy var descriptionHeaderLabel = {
        $0.text = L10n.Localizable.OfferDetails.Description.header
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private lazy var descriptionLabel = {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    // MARK: - Initial state

    func setupInitialState() {
        addSubview(mainVStackView)
        mainVStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Configuration

    func configure(with viewModel: ViewModel) {
        priceLabel.text = viewModel.price
        titleLabel.text = viewModel.title
        viewModel.loadCity(cityLabel)
        viewModel.loadInfo { [weak self] info in
            guard let self else {
                return
            }
            info.forEach {
                self.infoDetailsVStackView.addArrangedSubview(
                    self.createSpecLabel(title: $0.0, value: $0.1)
                )
            }
        }
        descriptionLabel.text = viewModel.description
        onCalendar = viewModel.onCalendar
    }

}

// MARK: - Private methods

private extension MyOfferDetailsView {

    func createSpecLabel(title: String, value: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)

        let text = "\(title): \(value)"
        let attributedText = NSMutableAttributedString(string: text)
        let titleRange = (text as NSString).range(of: title)
        attributedText.addAttribute(.foregroundColor, value: UIColor.secondaryLabel, range: titleRange)
        label.attributedText = attributedText

        return label
    }

}
