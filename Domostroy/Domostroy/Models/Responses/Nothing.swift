//
//  VoidResponse.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 25.05.2025.
//

import NodeKit

/// This had to be created because of a bug where in NodeKit you can't send
/// a request that has a multipart body but expects Void in return
public struct NothingEntity: DTODecodable {
    public typealias DTO = NothingEntry
    public static func from(dto: DTO) throws -> Self { .init() }
}

public struct NothingEntry: RawDecodable {
    public typealias Raw = Json
    public static func from(raw: Raw) throws -> Self { .init() }
}
