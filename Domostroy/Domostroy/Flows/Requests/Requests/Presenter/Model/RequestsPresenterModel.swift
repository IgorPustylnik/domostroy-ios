//
//  RequestsPresenterModel.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 11.05.2025.
//

import Foundation

struct RequestsPresenterModel {
    enum Segment: Int, CaseIterable {
        case outgoing
        case incoming

        var description: String {
            switch self {
            case .outgoing:
                return L10n.Localizable.Requests.Outgoing.title
            case .incoming:
                return L10n.Localizable.Requests.Incoming.title
            }
        }
    }

}
