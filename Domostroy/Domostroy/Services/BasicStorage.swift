//
//  BasicStorage.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 29.04.2025.
//

import Foundation

public protocol BasicStorage {
    func set<T: Codable>(_ value: T, for key: BasicStorageKey<T>)
    func get<T: Codable>(for key: BasicStorageKey<T>) -> T?
    func remove<T>(for key: BasicStorageKey<T>)
}

public struct BasicStorageKey<T: Codable> {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

public extension BasicStorageKey {
    static var serverHost: BasicStorageKey<String> { .init("serverHost") }
    static var myRole: BasicStorageKey<Role> { .init("myRole") }
    static var amBanned: BasicStorageKey<Bool> { .init("amBanned") }
    static var passedOnboarding: BasicStorageKey<Bool> { .init("passedOnboarding") }
    static var defaultCity: BasicStorageKey<CityEntry> { .init("defaultCity") }
}
