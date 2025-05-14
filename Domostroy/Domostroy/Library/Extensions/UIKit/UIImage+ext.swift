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

// MARK: - Avatars

extension UIImage {
    static func initialsAvatar(
        name: String,
        size: CGSize = CGSize(width: 100, height: 100),
        font: UIFont = .systemFont(ofSize: 40, weight: .medium),
        hashable: AnyHashable
    ) -> UIImage {
        let initials = name
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .prefix(2)
            .compactMap { $0.first }
            .map { String($0).uppercased() }
            .joined()

        let bgColor = neutralColor(for: hashable)
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { _ in
            let rect = CGRect(origin: .zero, size: size)

            bgColor.setFill()
            UIRectFill(rect)

            let style = NSMutableParagraphStyle()
            style.alignment = .center

            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.white,
                .paragraphStyle: style
            ]

            let textSize = initials.size(withAttributes: attributes)
            let textRect = CGRect(
                x: (size.width - textSize.width) / 2,
                y: (size.height - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )

            initials.draw(in: textRect, withAttributes: attributes)
        }
    }

    private static func neutralColor(for hashable: AnyHashable) -> UIColor {
        let description = String(describing: hashable)
        let hash = description.utf8.reduce(0) { ($0 << 5) &+ $0 &+ Int($1) }

        let colors: [UIColor] = [
            .AvatarBackground.deepBlue,
            .AvatarBackground.purple,
            .AvatarBackground.darkGreen,
            .AvatarBackground.terracotta,
            .AvatarBackground.steelBlue,
            .AvatarBackground.amber,
            .AvatarBackground.graphite
        ]

        return colors[abs(hash) % colors.count]
    }
}
