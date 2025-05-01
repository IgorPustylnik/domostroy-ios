//
//  SecureStorage.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 29.04.2025.
//

import Foundation
import Security

public protocol SecureStorage {
    @discardableResult
    func saveToken(_ token: AuthTokenEntity) -> Bool
    func loadToken() -> AuthTokenEntity?
    func deleteToken()
}
