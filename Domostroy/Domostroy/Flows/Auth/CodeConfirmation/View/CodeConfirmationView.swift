//
//  CodeConfirmationView.swift
//  Domostroy
//
//  Created by igorpustylnik on 05/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import SnapKit

final class CodeConfirmationView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let insets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let codeFieldHeight: CGFloat = 80
        static let vSpacing: CGFloat = 16
    }

    // MARK: - UI Elements

    private lazy var titleLabel: UILabel = {
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.text = L10n.Localizable.Auth.CodeConfirmation.title
        return $0
    }(UILabel())

    private var codeField: DCodeField?

    private lazy var messageLabel: UILabel = {
        $0.font = .systemFont(ofSize: 16, weight: .light)
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    // MARK: - Properties

    var onConfirm: ((String) -> Void)?

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    private func setupUI() {
        backgroundColor = .systemBackground
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(Constants.insets)
        }
    }

    private func setupCodeField() {
        guard let codeField else {
            return
        }
        codeField.removeFromSuperview()
        addSubview(codeField)
        codeField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.vSpacing)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(Constants.insets)
            make.height.equalTo(Constants.codeFieldHeight)
            make.bottom.equalToSuperview()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            codeField.focusFirstField()
        }
    }

    private func setupMessageLabel(_ email: String) {
        guard let codeField else {
            return
        }
        messageLabel.removeFromSuperview()

        let message = L10n.Localizable.Auth.CodeConfirmation.sentToEmailMessage(email)
        let attributedMessage = NSMutableAttributedString(string: message)
        let emailRange = (message as NSString).range(of: email)
        attributedMessage.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .regular), range: emailRange)
        messageLabel.attributedText = attributedMessage

        addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(codeField.snp.bottom).offset(Constants.vSpacing)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(Constants.insets)
        }
    }

    // MARK: - Configuration

    func configure(length: Int, email: String) {
        codeField = .init(length: length)
        codeField?.onCodeCompleted = { [weak self] in
            guard let codeField = self?.codeField else {
                return
            }
            self?.onConfirm?(codeField.getCode())
        }
        setupCodeField()
        setupMessageLabel(email)
    }

}
