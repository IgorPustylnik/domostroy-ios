//
//  CreateRequestView.swift
//  Domostroy
//
//  Created by igorpustylnik on 17/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit

final class CreateRequestView: UIView {

    // MARK: - ViewModel

    struct ViewModel {
        let imageUrl: URL?
        let loadImage: (URL?, UIImageView) -> Void
        let title: String
        let price: String
        let onCalendar: EmptyClosure?
    }

    // MARK: - Constants

    private enum Constants {
        static let mainVStackSpacing: CGFloat = 20
        static let offerImageSize: CGSize = .init(width: 40, height: 40)
        static let offerHStackSpacing: CGFloat = 16
        static let detailsVStackSpacing: CGFloat = 10
        static let infoVStackSpacing: CGFloat = 10
    }

    // MARK: - UI Elements

    private lazy var mainVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.mainVStackSpacing
        $0.addArrangedSubview(offerHStackView)
        $0.addArrangedSubview(detailsVStackView)
        $0.addArrangedSubview(infoVStackView)
        return $0
    }(UIStackView())

    private lazy var offerHStackView = {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = Constants.offerHStackSpacing
        $0.addArrangedSubview(offerImageView)
        $0.addArrangedSubview(offerTitleLabel)
        $0.addArrangedSubview(priceLabel)
        return $0
    }(UIStackView())

    private lazy var offerImageView = {
        $0.layer.cornerRadius = Constants.offerImageSize.width / 5
        $0.layer.masksToBounds = true
        $0.backgroundColor = .secondarySystemBackground
        $0.contentMode = .scaleAspectFill
        $0.snp.makeConstraints { make in
            make.size.equalTo(Constants.offerImageSize)
        }
        return $0
    }(UIImageView())

    private lazy var offerTitleLabel = {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 0
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return $0
    }(UILabel())

    private lazy var priceLabel = {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .secondaryLabel
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        return $0
    }(UILabel())

    private lazy var detailsVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.detailsVStackSpacing
        $0.addArrangedSubview(detailsHeaderLabel)
        $0.addArrangedSubview(calendarButton)
        return $0
    }(UIStackView())

    private lazy var detailsHeaderLabel = makeHeaderLabel("Rent details")

    private lazy var calendarButton = {
        $0.image = .Buttons.calendar.withTintColor(.label, renderingMode: .alwaysOriginal)
        $0.imagePlacement = .right
        // TODO: Localize
        $0.title = "Select dates"
        $0.setAction { [weak self] in
            self?.onCalendar?()
        }
        return $0
    }(DButton(type: .calendar))

    private lazy var infoVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.infoVStackSpacing
        $0.addArrangedSubview(infoHeaderLabel)
        $0.addArrangedSubview(info1Label)
        $0.addArrangedSubview(info2Label)
        return $0
    }(UIStackView())

    private lazy var infoHeaderLabel = makeHeaderLabel("Communication with lessor")

    private lazy var info1Label = {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
        // TODO: Localize
        $0.text = "Сможете связаться с арендодателем после создания брони."
        return $0
    }(UILabel())

    private lazy var info2Label = {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
        // TODO: Localize
        $0.text = "Арендодатель получит контактные данные, указанные в вашем профиле."
        return $0
    }(UILabel())

    // MARK: - Properties

    private var onCalendar: EmptyClosure?

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - UI Setup

    private func setupUI() {
        addSubview(mainVStackView)
        mainVStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

// MARK: - Reusable UI

private extension CreateRequestView {
    func makeHeaderLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }
}

// MARK: - Configuration

extension CreateRequestView {
    func configure(with viewModel: ViewModel) {
        viewModel.loadImage(viewModel.imageUrl, offerImageView)
        offerTitleLabel.text = viewModel.title
        priceLabel.text = viewModel.price
        onCalendar = viewModel.onCalendar
    }

    func configureCalendar(with description: String) {
        calendarButton.title = description
    }
}
