//
//  AlertPresenter.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 26.05.2025.
//

import Foundation
import UIKit

enum AlertPresenter {

    static func confirm(
        title: String,
        message: String?,
        onConfirm: @escaping EmptyClosure
    ) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let positiveAction = UIAlertAction(title: L10n.Localizable.Common.Button.yes, style: .default) { _ in
                onConfirm()
            }
            let negativeAction = UIAlertAction(title: L10n.Localizable.Common.Button.cancel, style: .cancel)
            alert.addAction(negativeAction)
            alert.addAction(positiveAction)
            UIApplication.topViewController()?.present(alert, animated: true)
        }
    }

    static func enterText(
        title: String,
        message: String?,
        placeholder: String?,
        onConfirm: @escaping (String?) -> Void,
        onCancel: EmptyClosure? = nil
    ) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addTextField { textField in
                textField.placeholder = placeholder
            }

            let cancelAction = UIAlertAction(title: L10n.Localizable.Common.Button.cancel, style: .cancel) { _ in
                onCancel?()
            }
            let okAction = UIAlertAction(title: L10n.Localizable.Common.Button.ok, style: .default) { _ in
                var inputText = alert.textFields?.first?.text
                if let text = inputText {
                    inputText = text.isEmpty ? nil : text
                }
                onConfirm(inputText)
            }

            alert.addAction(cancelAction)
            alert.addAction(okAction)

            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        }
    }

}
