//
//  PaginatorView.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 07.04.2025.
//

import UIKit
import SnapKit
import ReactiveDataDisplayManager

final class PaginatorView: UIView {

    private var retryAction: (() -> Void)?

    private lazy var indicator = DLoadingIndicator()

    private lazy var errorLabel = {
        $0.textAlignment = .center
        return $0
    }(UILabel())

    private lazy var retryButton = {
        $0.title = L10n.Localizable.Common.Button.retry
        $0.setAction {
            self.onRetryTapped()
        }
        return $0
    }(DButton())

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialState()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupInitialState()
    }

    private func setupInitialState() {
        backgroundColor = .clear
        isUserInteractionEnabled = false
        addActvityIndicator()
        addErrorStateViews()
    }

    private func addActvityIndicator() {
        addSubview(indicator)
        indicator.accessibilityIdentifier = String(describing: Self.self)

        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func addErrorStateViews() {
        addSubview(errorLabel)
        addSubview(retryButton)

        errorLabel.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview().inset(16)
        }
        retryButton.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }

        errorLabel.isHidden = true
        retryButton.isHidden = true
    }

    @objc
    private func onRetryTapped() {
        showError(nil)
        retryAction?()
    }
}

// MARK: - ProgressDisplayableItem

extension PaginatorView: ProgressDisplayableItem {

    func setOnRetry(action: @autoclosure @escaping () -> Void) {
        retryAction = action
    }

    func showProgress(_ isLoading: Bool) {
        indicator.isHidden = !isLoading
    }

    func showError(_ error: Error?) {
        if let error {
            isUserInteractionEnabled = true
            errorLabel.isHidden = false
            retryButton.isHidden = false

            errorLabel.text = error.localizedDescription
        } else {
            isUserInteractionEnabled = false
            errorLabel.isHidden = true
            retryButton.isHidden = true
        }
    }

}
