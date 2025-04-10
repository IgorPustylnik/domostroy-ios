//
//  Double+ext.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 10.04.2025.
//

extension Double {
    var stringDroppingTrailingZero: String {
        String(format: "%g", self)
    }
}
