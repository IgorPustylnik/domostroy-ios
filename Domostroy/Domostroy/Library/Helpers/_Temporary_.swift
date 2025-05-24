//
//  _Temporary_.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 08.04.2025.
//

import Foundation
import Combine
import NodeKit

// swiftlint:disable force_unwrapping
struct _Temporary_Mock_NetworkService {
    func getUsers(
        query: String?,
        paginationEntity: PaginationRequestEntity
    ) -> AnyPublisher<NodeResult<PageEntity<UserDetailsEntity>>, Never> {
        Just(.success(
            PageEntity(
                pagination: .init(totalElements: 5, totalPages: 1),
                data: [
                    UserDetailsEntity(
                        id: 1,
                        name: "test name",
                        email: "email@mail.ru",
                        phoneNumber: "79525510773",
                        offersAmount: 4,
                        isBanned: false,
                        isAdmin: false,
                        registrationDate: .now
                    ),
                    UserDetailsEntity(
                        id: 2452,
                        name: "test name",
                        email: "email@mail.ru",
                        phoneNumber: "79525510773",
                        offersAmount: 4,
                        isBanned: false,
                        isAdmin: false,
                        registrationDate: .now
                    ),
                    UserDetailsEntity(
                        id: 2452,
                        name: "test name",
                        email: "email@mail.ru",
                        phoneNumber: "79525510773",
                        offersAmount: 4,
                        isBanned: false,
                        isAdmin: false,
                        registrationDate: .now
                    ),
                    UserDetailsEntity(
                        id: 2452,
                        name: "test name",
                        email: "email@mail.ru",
                        phoneNumber: "79525510773",
                        offersAmount: 4,
                        isBanned: false,
                        isAdmin: false,
                        registrationDate: .now
                    ),
                    UserDetailsEntity(
                        id: 1,
                        name: "test name",
                        email: "email@mail.ru",
                        phoneNumber: "79525510773",
                        offersAmount: 4,
                        isBanned: true,
                        isAdmin: false,
                        registrationDate: .now
                    ),
                    UserDetailsEntity(
                        id: 1,
                        name: "test name",
                        email: "email@mail.ru",
                        phoneNumber: "79525510773",
                        offersAmount: 4,
                        isBanned: false,
                        isAdmin: true,
                        registrationDate: .now
                    )
                ]
            )
        )).eraseToAnyPublisher()
    }
}
