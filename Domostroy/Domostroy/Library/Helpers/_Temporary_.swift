//
//  _Temporary_.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 08.04.2025.
//

import Foundation

enum _Temporary_EndpointConstructor {
    case user(id: Int)

    var url: URL? {
        guard let host = InfoPlist.serverHost else {
            return nil
        }
        switch self {
        case .user(let id):
            return URL(string: host + "/api/user/\(id)")
        }
    }
}

struct _Temporary_Mock_NetworkService {
    func fetchOffers(page: Int, pageSize: Int) async -> OffersPage {
        try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        return OffersPage(
            pagination: .init(
                currentPage: page,
                perPage: pageSize,
                totalItems: 100,
                totalPages: 10
            ),
            offers: (0..<pageSize).map { i in
                    .init(
                        id: Int.random(in: 0...1000),
                        name: "Test \(page * pageSize + i)",
                        description: "Test description",
                        category: .init(id: 1, name: "Category"),
                        currency: .rub,
                        price: 500,
                        isFavorite: true,
                        images: [],
                        city: .init(id: 1, name: "Воронеж"),
                        userId: 0,
                        calendarId: 0
                    )
            }
        )
    }
}
