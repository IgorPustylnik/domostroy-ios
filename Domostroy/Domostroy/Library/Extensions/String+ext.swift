//
//  String+ext.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 24.04.2025.
//

import UIKit

extension String {
    func heightForWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let boundingBox = self.boundingRect(
            with: size,
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
        )
        return ceil(boundingBox.height)
    }
}
