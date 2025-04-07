//
//  RegisterDTO.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 07.04.2025.
//

import Foundation

struct RegisterDTO: Encodable {
    var name: String
    var surname: String
    var phoneNumber: String
    var email: String
    var password: String
}
