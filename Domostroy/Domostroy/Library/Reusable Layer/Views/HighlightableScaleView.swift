//
//  HighlightableScaleView.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 26.04.2025.
//

import UIKit
import ReactiveDataDisplayManager

protocol HighlightableScaleView: UIView & HighlightableItem {
    var highlightScaleFactor: CGFloat { get }
}

extension HighlightableScaleView {
    func applyUnhighlightedStyle() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }

    func applyHighlightedStyle() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: self.highlightScaleFactor, y: self.highlightScaleFactor)
        }
    }

    func applyDeselectedStyle() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }

    func applySelectedStyle() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: self.highlightScaleFactor, y: self.highlightScaleFactor)
        }
    }
}
