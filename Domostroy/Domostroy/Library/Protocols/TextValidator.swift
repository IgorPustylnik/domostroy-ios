//
//  TextValidator.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 04.04.2025.
//

typealias ValidationResult = (isValid: Bool, errorMessage: String?)

protocol TextValidator {
    func validate(_ text: String?) -> ValidationResult
}
