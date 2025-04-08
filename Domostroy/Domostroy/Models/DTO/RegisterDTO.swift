//
//  RegisterDTO.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 07.04.2025.
//

import Foundation

struct RegisterDTO: Encodable {
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var email: String
    var password: String
}
