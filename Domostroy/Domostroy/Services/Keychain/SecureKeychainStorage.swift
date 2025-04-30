//
//  SecureKeychainStorage.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 29.04.2025.
//

import Foundation
import Security

final class SecureKeychainStorage: SecureStorage {

    // MARK: - Keys

    private enum Keys {
        static let authToken = "authToken"
    }

    // MARK: - Auth Token

    func saveToken(_ token: AuthTokenEntity) -> Bool {
        guard let data = try? JSONEncoder().encode(token.toDTO()) else {
            return false
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: Keys.authToken,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    func loadToken() -> AuthTokenEntity? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: Keys.authToken,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let data = result as? Data,
              let tokenEntry = try? JSONDecoder().decode(AuthTokenEntry.self, from: data)
        else {
            return nil
        }

        return try? .from(dto: tokenEntry)
    }

    func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: Keys.authToken
        ]

        SecItemDelete(query as CFDictionary)
    }
}
