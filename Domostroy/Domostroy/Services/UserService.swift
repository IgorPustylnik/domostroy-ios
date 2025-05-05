//
//  UserService.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 28.04.2025.
//

import Foundation
import Combine
import NodeKit

public protocol UserService {

    // MARK: - GET

    func getUser(id: Int) -> AnyPublisher<NodeResult<UserEntity>, Never>

    func getMyUser() -> AnyPublisher<NodeResult<MyUserEntity>, Never>

    // MARK: - POST

    func editInfo(editUserInfoEntity: EditUserInfoEntity) -> AnyPublisher<NodeResult<Void>, Never>

    func changePassword(changePasswordEntity: ChangePasswordEntity) -> AnyPublisher<NodeResult<Void>, Never>

}
