//
//  OffersPageEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 27.04.2025.
//

import Foundation
import NodeKit

public struct PageEntry<Entry: Decodable & RawDecodable> {
    public let pagination: PaginationEntry
    private let data: PageData<Entry>
    public var content: [Entry] {
        data.content
    }
}

extension PageEntry: Decodable, RawDecodable {
    public typealias Raw = Json
}

private struct PageData<Entry: Decodable & RawDecodable>: Decodable, RawDecodable {
    typealias Raw = Json

    public let content: [Entry]
}
