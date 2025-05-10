//
//  _Temporary_.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 08.04.2025.
//

import Foundation
import Combine
import NodeKit

struct _Temporary_Mock_NetworkService {

    func fetchCalendar(id: Int) async -> OfferCalendar {
        let url = URL.applicationDirectory
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return OfferCalendar(
            startDate: Calendar.current.date(
                from: .init(
                    year: 2025,
                    month: 4,
                    day: 1
                )
            )!,
            endDate: Calendar.current.date(
                from: .init(
                    year: 2026,
                    month: 4,
                    day: 1
                )
            )!,
            forbiddenDates: [
                Calendar.current.date(
                    from: .init(
                        year: 2025,
                        month: 4,
                        day: 13
                    )
                )!,
                Calendar.current.date(
                    from: .init(
                        year: 2025,
                        month: 4,
                        day: 15
                    )
                )!,
                Calendar.current.date(
                    from: .init(
                        year: 2025,
                        month: 4,
                        day: 26
                    )
                )!
            ]
        )
    }

    enum RequestType {
        case incoming
        case outgoing
    }

    func fetchRequests() async -> NodeResult<PageEntity<RentalRequestEntity>> {
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        return .success(
            .init(
                pagination: .init(totalElements: 10, totalPages: 2),
                data: [
                    .init(
                        id: 0,
                        status: .accepted,
                        dates: [.now],
                        createdAt: .now,
                        resolvedAt: nil,
                        offer: makeRentalOffer(),
                        user: makeRentalUser()
                    ),
                    .init(
                        id: 0,
                        status: .pending,
                        dates: [.now],
                        createdAt: .now,
                        resolvedAt: nil,
                        offer: makeRentalOffer(),
                        user: makeRentalUser()
                    ),
                    .init(
                        id: 0,
                        status: .declined,
                        dates: [.now],
                        createdAt: .now,
                        resolvedAt: nil,
                        offer: makeRentalOffer(),
                        user: makeRentalUser()
                    ),
                    .init(
                        id: 0,
                        status: .declined,
                        dates: [.now],
                        createdAt: .now,
                        resolvedAt: nil,
                        offer: makeRentalOffer(),
                        user: makeRentalUser()
                    ),
                    .init(
                        id: 0,
                        status: .pending,
                        dates: [.now],
                        createdAt: .now,
                        resolvedAt: nil,
                        offer: makeRentalOffer(),
                        user: makeRentalUser()
                    ),
                    .init(
                        id: 0,
                        status: .accepted,
                        dates: [.now],
                        createdAt: .now,
                        resolvedAt: nil,
                        offer: makeRentalOffer(),
                        user: makeRentalUser()
                    ),
                    .init(
                        id: 0,
                        status: .pending,
                        dates: [.now],
                        createdAt: .now,
                        resolvedAt: nil,
                        offer: makeRentalOffer(),
                        user: makeRentalUser()
                    ),
                    .init(
                        id: 0,
                        status: .accepted,
                        dates: [.now],
                        createdAt: .now,
                        resolvedAt: nil,
                        offer: makeRentalOffer(),
                        user: makeRentalUser()
                    )
                ]
            )
        )
    }

    private func makeRentalOffer() -> RentalRequestOfferEntity {
        .init(
            id: 0,
            title: "Test",
            photoUrl: .applicationDirectory,
            price: .init(value: 500, currency: .rub),
            city: "City"
        )
    }

    private func makeRentalUser() -> RentalRequestUserEntity {
        .init(id: 0, name: "User", phoneNumber: "+78005553535")
    }
}

struct OfferCalendar: Codable {
    let startDate: Date
    let endDate: Date
    let forbiddenDates: [Date]
}
