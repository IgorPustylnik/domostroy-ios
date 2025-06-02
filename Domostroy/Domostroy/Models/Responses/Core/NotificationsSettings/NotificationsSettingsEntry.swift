//
//  NotificationsSettingsEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 02.06.2025.
//

import NodeKit

public struct NotificationsSettingsEntry {
    let notificationsEnabled: Bool
}

extension NotificationsSettingsEntry: Decodable, RawDecodable {
    public typealias Raw = Json
}
