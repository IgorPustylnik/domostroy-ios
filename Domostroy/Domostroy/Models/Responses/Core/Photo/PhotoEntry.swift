//
//  PhotoEntry.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 25.05.2025.
//

import Foundation
import NodeKit

public struct PhotoEntry {
    public let id: Int
    public let url: URL
}

extension PhotoEntry: Decodable, RawDecodable {
    public typealias Raw = Json
}
