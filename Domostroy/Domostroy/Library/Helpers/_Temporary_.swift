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

    static var i = 0

    func fetchRequests() async -> NodeResult<PageEntity<RentalRequestEntity>> {
        _Temporary_Mock_NetworkService.i += 1
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        if _Temporary_Mock_NetworkService.i % 3 != 1 {
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
        } else {
            return .success(.init(pagination: .init(totalElements: 0, totalPages: 0), data: []))
        }
    }

    func fetchRentalRequest() async -> NodeResult<RentalRequestEntity> {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        _Temporary_Mock_NetworkService.i += 1
        let status: RequestStatus
        switch _Temporary_Mock_NetworkService.i % 3 {
        case 0:
            status = .accepted
        case 1:
            status = .pending
        case 2:
            status = .declined
        default:
            status = .pending
        }
        return .success(
            .init(
                id: 0,
                status: status,
                dates: [.now],
                createdAt: .now,
                resolvedAt: .now,
                offer: .init(
                    id: 0,
                    title: "test offer test offer test offer test offer test offer test offer",
                    photoUrl: .applicationDirectory,
                    price: .init(value: 100, currency: .rub),
                    city: "test city"
                ),
                user: .init(
                    id: 0,
                    firstName: "test",
                    lastName: "name",
                    phoneNumber: "test phone"
                )
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
        .init(id: 0, firstName: "User", lastName: nil, phoneNumber: "+78005553535")
    }
}

struct OfferCalendar: Codable {
    let startDate: Date
    let endDate: Date
    let forbiddenDates: [Date]
}
