//
//  EditOfferEntity.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 24.05.2025.
//

import Foundation
import NodeKit
import UIKit

public struct EditOfferEntity {
    public let id: Int
    public let title: String
    public let description: String
    public let categoryId: Int
    public let price: PriceEntity
    public let cityId: Int
    public let oldPhotosIds: [Int]
    public let photos: [UIImage]
}

extension EditOfferEntity: DTOEncodable {
    public typealias DTO = EditOfferEntry

    public func toDTO() throws -> DTO {
        .init(
            metadata: .init(
                id: id,
                title: title,
                description: description,
                categoryId: categoryId,
                price: price.value,
                currency: price.currency.rawValue,
                cityId: cityId,
                photoIds: oldPhotosIds
            ),
            file: photos.compactMap {
                $0.compressImage(maxSize: CommonConstants.maxPhotoSizeBytes)
            }
        )
    }
}
