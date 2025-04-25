//
//  TitleCollectionReusableView.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 10.04.2025.
//

import UIKit
import ReactiveDataDisplayManager

final class TitleCollectionReusableView: UICollectionReusableView, AccessibilityItem, CalculatableHeightItem {

    // MARK: - Constants

    private enum Constants {
        static let insets: UIEdgeInsets = .init(top: 8, left: 0, bottom: 8, right: 0)
    }

    // MARK: - CalculatableHeightItem

    static func getHeight(forWidth width: CGFloat, with model: String) -> CGFloat {
        let verticalInsets = Constants.insets.top + Constants.insets.bottom
        let titleHeight = model.getHeight(withConstrainedWidth: width,
                                          font: .preferredFont(forTextStyle: .headline))
        return verticalInsets + titleHeight
    }

    // MARK: - UI Elements

    private var titleLabel = {
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        return $0
    }(UILabel())

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.insets).priority(.high)
        }
    }

    // MARK: - AccessibilityItem

    var labelStrategy: AccessibilityStringStrategy { .from(titleLabel) }
    var traitsStrategy: AccessibilityTraitsStrategy { .from(titleLabel) }

    // MARK: - Internal methods

    func configure(with model: String) {
        titleLabel.text = model
    }

}

// MARK: - Helper

extension String {

    func getHeight(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)

        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font],
                                            context: nil)

        return ceil(boundingBox.height)
    }

}
