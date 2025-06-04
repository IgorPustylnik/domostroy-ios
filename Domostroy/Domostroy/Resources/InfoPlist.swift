//
//  InfoPlist.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 08.04.2025.
//

import Foundation

enum InfoPlist {
    static var serverHost: String? {
        let basicStorage: BasicStorage? = ServiceLocator.shared.resolve()
        if let host = basicStorage?.get(for: .serverHost) {
            return host
        }
        return Bundle.main.infoDictionary?["SERVER_HOST"] as? String
    }

    static var appMetricaAPIKey: String? {
        Bundle.main.infoDictionary?["APPMETRICA_API_KEY"] as? String
    }
}
