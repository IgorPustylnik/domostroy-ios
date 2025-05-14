//
//  RequestStatus.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 11.05.2025.
//

public enum RequestStatus: String, Codable {
    case accepted = "ACCEPTED"
    case pending = "PENDING"
    case declined = "REJECTED"
}
