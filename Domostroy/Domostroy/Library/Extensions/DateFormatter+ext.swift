//
//  DateFormatter.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 05.05.2025.
//

import Foundation

extension DateFormatter {
    static var iso8601WithMicroseconds: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }

    static var yyyymmdd: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}
