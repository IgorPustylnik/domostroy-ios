//
//  BasicUserDefaultsStorage.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 29.04.2025.
//

import Foundation

public final class BasicUserDefaultsStorage: BasicStorage {

    // MARK: - Properties

    private let defaults: UserDefaults

    // MARK: - Init

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
}

// MARK: - BasicStorage

public extension BasicUserDefaultsStorage {
    func set<T: Codable>(_ value: T, for key: BasicStorageKey<T>) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(value) {
            defaults.set(encoded, forKey: key.rawValue)
        }
    }

    func get<T: Codable>(for key: BasicStorageKey<T>) -> T? {
        guard let data = defaults.data(forKey: key.rawValue) else {
            return nil
        }
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }

    func remove<T>(for key: BasicStorageKey<T>) {
        defaults.removeObject(forKey: key.rawValue)
    }
}
