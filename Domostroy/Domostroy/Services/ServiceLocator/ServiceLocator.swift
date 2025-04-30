//
//  ServiceLocator.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 29.04.2025.
//

import Foundation

public final class ServiceLocator {
    public static let shared = ServiceLocator()

    // MARK: - Private properties

    private lazy var services = [String: Any]()

    // MARK: - Init

    private init() {}

    // MARK: - Private methods

    private func typeName(_ some: Any) -> String {
        return (some is Any.Type) ? "\(some)" : "\(type(of: some))"
    }

    // MARK: Public methods

    public func register<T>(service: T) {
        let key = typeName(T.self)
        services[key] = service
    }

    public func resolve<T>() -> T? {
        let key = typeName(T.self)
        return services[key] as? T
    }

}
