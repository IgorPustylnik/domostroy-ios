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
        let url = URL.applicationDirectory
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
                        images: [url, url, url, url],
                        city: .init(id: 1, name: "Воронеж"),
                        userId: 0,
                        calendarId: 0
                    )
            }
        )
    }

    func fetchOffer(id: Int) async -> Offer {
        let url = URL.applicationDirectory
        try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        return Offer(
            id: 0,
            name: "Шуруповёрт Makita",
            description: """
Продаю почти новый шуруповерт Makita. Состояние: новый (ну, почти, если бы не пару мелких происшествий). Сгорел, но это не беда, бывает. Так что, если вам нужно что-то, что выглядит как предмет из апокалипсиса, но всё ещё работает (возможно), то это как раз для вас.

- Комплектация: Шуруповерт, пару незаметных следов от огня, и, конечно же, куча пепла, который можно использовать как декор на вашем рабочем столе.
- Потенциал: 90% мощности остаётся. 10% — немного перегорели, но это не мешает создавать неповторимую атмосферу. Вполне возможно, что шуруповерт снова заработает, как только выйдет из своего «периода восстановления».
- Уникальная особенность: Никакой запах нового инструмента, зато гарантированно душевный запах "горелого". Подарит вам незабываемые воспоминания.
- Зачем покупать новый, если можно взять с историей? Этот шуруповерт был пережившим свою жизнь, и он готов продолжить свои подвиги на вашем рабочем месте.

Состояние: Новый. Не верите? Проверьте сами, только осторожно — и не забудьте про огнетушитель.
""",
            category: .init(id: 0, name: "category"),
            currency: .rub,
            price: 100,
            isFavorite: true,
            images: [url, url, url, url],
            city: .init(id: 0, name: "Воронеж"),
            userId: 0,
            calendarId: 0
        )
    }
}
