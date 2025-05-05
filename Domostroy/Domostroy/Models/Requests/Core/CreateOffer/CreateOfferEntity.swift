//
//  CreateOfferEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 29.04.2025.
//

import Foundation
import NodeKit
import UIKit

public struct CreateOfferEntity {
    public let title: String
    public let description: String
    public let categoryId: Int
    public let price: PriceEntity
    public let cityId: Int
    public let rentDates: Set<Date>
    public let photos: [UIImage]
}

extension CreateOfferEntity: DTOEncodable {
    public typealias DTO = CreateOfferEntry

    public func toDTO() throws -> DTO {
        .init(
            metadata: .init(
                title: title,
                description: description,
                categoryId: categoryId,
                price: price.value,
                currency: price.currency.rawValue,
                cityId: cityId,
                rentDates: rentDates
            ),
            file: photos.compactMap {
                $0.resizedToFit(fitSize: CommonConstants.maxPhotoSize).jpegData(
                    compressionQuality: CommonConstants.compressionQuality
                )
            }
        )
    }
}
