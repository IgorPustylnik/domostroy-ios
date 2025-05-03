//
//  SortViewController.swift
//  Domostroy
//
//  Created by igorpustylnik on 22/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit

final class SortViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let insets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
    }

    // MARK: - UI Elements

    private lazy var mainVStackView = {
        $0.axis = .vertical
        return $0
    }(UIStackView())

    private lazy var applyButton = {
        $0.title = L10n.Localizable.Sort.Button.apply
        $0.setAction { [weak self] in
            guard let value = self?.radioButtonGroup.selectedValue else {
                return
            }
            self?.output?.apply(sort: value)
        }
        return $0
    }(DButton())

    // MARK: - Properties

    var radioButtonGroup = DRadioButtonGroup<SortViewModel>()

    var output: SortViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSheetPresentation()
        output?.viewLoaded()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updatePreferredContentSize()
    }

    private func setupUI() {
        title = L10n.Localizable.Sort.title
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .close, target: self, action: #selector(close))
        view.addSubview(mainVStackView)
        view.addSubview(applyButton)
        mainVStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(Constants.insets)
            make.bottom.lessThanOrEqualTo(applyButton.snp.top).offset(Constants.insets.bottom)
        }
        applyButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.insets)
        }
    }
}

// MARK: - Sheet presentation

private extension SortViewController {
    func setupSheetPresentation() {
        if let sheet = sheetPresentationController {
            sheet.detents = [
                .custom { _ in
                    return self.preferredContentSize.height
                }
            ]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
    }

    func updatePreferredContentSize() {
        let fittingSize = CGSize(width: view.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let fullHeight = view.systemLayoutSizeFitting(fittingSize,
                                                      withHorizontalFittingPriority: .required,
                                                      verticalFittingPriority: .fittingSizeLevel).height

        preferredContentSize = CGSize(width: view.bounds.width, height: fullHeight)
        sheetPresentationController?.animateChanges {}
    }
}

// MARK: - SortViewInput

extension SortViewController: SortViewInput {

    func setup(with options: [SortViewModel], initial: SortViewModel) {
        mainVStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        options.forEach { value in
            let radioOption = makeRadioButton(value: value, isInitial: value == initial)
            mainVStackView.addArrangedSubview(radioOption)
        }
    }

}

// MARK: - Private Methods

private extension SortViewController {
    func makeRadioButton(value: SortViewModel, isInitial: Bool) -> DRadioButton {
        let radio = DRadioButton()
        radio.setTitle(value.description)
        radioButtonGroup.add(button: radio, value: value)
        if isInitial {
            radioButtonGroup.select(button: radio)
        }
        return radio
    }
}

// MARK: - Selectors

@objc
private extension SortViewController {
    func close() {
        output?.dismiss()
    }
}
