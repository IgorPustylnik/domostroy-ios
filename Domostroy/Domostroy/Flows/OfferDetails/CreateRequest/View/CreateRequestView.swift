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
        let offer: ConciseOfferView.ViewModel
        let onCalendar: EmptyClosure
    }

    // MARK: - Constants

    private enum Constants {
        static let mainVStackSpacing: CGFloat = 20
        static let offerImageSize: CGSize = .init(width: 40, height: 40)
        static let offerHStackSpacing: CGFloat = 16
        static let detailsVStackSpacing: CGFloat = 10
        static let infoVStackSpacing: CGFloat = 10
        static let costVStackSpacing: CGFloat = 10
    }

    // MARK: - UI Elements

    private lazy var mainVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.mainVStackSpacing
        $0.addArrangedSubview(conciseOfferView)
        $0.addArrangedSubview(detailsVStackView)
        $0.addArrangedSubview(infoVStackView)
        $0.addArrangedSubview(totalCostVStackView)
        return $0
    }(UIStackView())

    private lazy var conciseOfferView = ConciseOfferView()

    private lazy var detailsVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.detailsVStackSpacing
        $0.addArrangedSubview(detailsHeaderLabel)
        $0.addArrangedSubview(calendarButton)
        return $0
    }(UIStackView())

    private lazy var detailsHeaderLabel = makeHeaderLabel(L10n.Localizable.CreateRequest.Details.header)

    private lazy var calendarButton = {
        $0.image = .Buttons.calendar.withTintColor(.label, renderingMode: .alwaysOriginal)
        $0.imagePlacement = .right
        $0.title = " "
        $0.setAction { [weak self] in
            self?.onCalendar?()
        }
        return $0
    }(DButton(type: .modalPicker))

    private lazy var infoVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.infoVStackSpacing
        $0.addArrangedSubview(infoHeaderLabel)
        $0.addArrangedSubview(info1Label)
        $0.addArrangedSubview(info2Label)
        return $0
    }(UIStackView())

    private lazy var infoHeaderLabel = makeHeaderLabel(L10n.Localizable.CreateRequest.Info.header)

    private lazy var info1Label = {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
        $0.text = L10n.Localizable.CreateRequest.Info.afterBooking
        return $0
    }(UILabel())

    private lazy var info2Label = {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
        $0.text = L10n.Localizable.CreateRequest.Info.contactData
        return $0
    }(UILabel())

    private lazy var totalCostVStackView = {
        $0.axis = .vertical
        $0.spacing = Constants.costVStackSpacing
        $0.addArrangedSubview(totalCostHeaderLabel)
        $0.addArrangedSubview(totalCostLabel)
        $0.addArrangedSubview(totalCostInfoLabel)
        $0.isHidden = true
        return $0
    }(UIStackView())

    private lazy var totalCostHeaderLabel = makeHeaderLabel(L10n.Localizable.CreateRequest.TotalCost.header)

    private lazy var totalCostLabel = {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private lazy var totalCostInfoLabel = {
        $0.font = .systemFont(ofSize: 12, weight: .light)
        $0.numberOfLines = 0
        $0.text = L10n.Localizable.CreateRequest.TotalCost.note
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
        calendarButton.setLoading(true)
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
        conciseOfferView.configure(with: viewModel.offer)
        onCalendar = viewModel.onCalendar
        calendarButton.setLoading(false)
    }

    func configureCalendar(with description: String) {
        calendarButton.title = description
    }

    func configureTotalCost(with totalCost: String?) {
        totalCostVStackView.isHidden = totalCost == nil
        totalCostLabel.text = totalCost
    }
}
