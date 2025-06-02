//
//  NotificationsSettingsEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 02.06.2025.
//

import NodeKit

public struct NotificationsSettingsEntity {
    let notificationsEnabled: Bool
}

extension NotificationsSettingsEntity: DTODecodable {
    public typealias DTO = NotificationsSettingsEntry

    public static func from(dto model: DTO) throws -> Self {
        .init(notificationsEnabled: model.notificationsEnabled)
    }
}
