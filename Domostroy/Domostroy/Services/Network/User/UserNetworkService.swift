//
//  UserNetworkService.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 28.04.2025.
//

import Foundation
import Combine
import NodeKit

public final class UserNetworkService: UserService {

    // MARK: - Properties

    private let secureStorage: SecureStorage
    private let basicStorage: BasicStorage

    // MARK: - Init

    init(secureStorage: SecureStorage, basicStorage: BasicStorage) {
        self.secureStorage = secureStorage
        self.basicStorage = basicStorage
    }

    // MARK: - GET

    public func getUser(id: Int) -> AnyPublisher<NodeResult<UserEntity>, Never> {
        makeBuilder()
            .route(.get, .other(id))
            .build()
            .nodeResultPublisher()
    }

    public func getMyUser() -> AnyPublisher<NodeResult<MyUserEntity>, Never> {
        makeBuilder()
            .route(.get, .my)
            .build()
            .nodeResultPublisher()
            .handleEvents(
                receiveOutput: { [weak self] result in
                    switch result {
                    case .success(let user):
                        self?.basicStorage.set(user.role, for: .myRole)
                        self?.basicStorage.set(user.isBanned, for: .amBanned)
                    case .failure:
                        break
                    }
                }
            ).eraseToAnyPublisher()
    }

    public func editInfo(editUserInfoEntity: EditUserInfoEntity) -> AnyPublisher<NodeResult<Void>, Never> {
        makeBuilder()
            .route(.patch, .info)
            .build()
            .nodeResultPublisher(for: editUserInfoEntity)
    }

    public func changePassword(changePasswordEntity: ChangePasswordEntity) -> AnyPublisher<NodeResult<Void>, Never> {
        makeBuilder()
            .route(.patch, .password)
            .build()
            .nodeResultPublisher(for: changePasswordEntity)
    }

    public func getNotificationsSettings() -> AnyPublisher<NodeResult<NotificationsSettingsEntity>, Never> {
        makeBuilder()
            .route(.get, .notificationsEnabled)
            .build()
            .nodeResultPublisher()
    }

    public func setNotifications(enabled: Bool) -> AnyPublisher<NodeResult<Void>, Never> {
        makeBuilder()
            .route(.patch, .my)
            .set(query: ["notificationsEnabled": enabled])
            .build()
            .nodeResultPublisher()
    }

}

// MARK: - Private methods

private extension UserNetworkService {
    func makeBuilder() -> URLChainBuilder<UserUrlRoute> {
        let token = secureStorage.loadToken()
        var builder = URLChainBuilder<UserUrlRoute>(serviceChainProvider: DURLServiceChainProvider())

        if let token {
            builder = builder.set(metadata: ["Authorization": "Bearer \(token.token)"])
        }

        return builder
    }
}
