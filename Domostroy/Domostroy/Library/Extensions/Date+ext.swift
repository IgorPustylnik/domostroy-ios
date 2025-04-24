//
//  Date+ext.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 25.04.2025.
//

import Foundation

extension Date {
    func monthAndYearString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "MMMM yyyy"

        return formatter.string(from: self)
    }
}
