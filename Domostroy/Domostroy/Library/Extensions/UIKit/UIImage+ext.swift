//
//  UIImage+ext.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 04.05.2025.
//

import UIKit

extension UIImage {
    func resizedToFit(fitSize: CGSize) -> UIImage {
        let originalSize = self.size

        guard originalSize.width > fitSize.width || originalSize.height > fitSize.height else {
            return self
        }

        let widthRatio = fitSize.width / originalSize.width
        let heightRatio = fitSize.height / originalSize.height
        let scaleFactor = min(widthRatio, heightRatio)

        let newSize = CGSize(
            width: originalSize.width * scaleFactor,
            height: originalSize.height * scaleFactor
        )

        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
