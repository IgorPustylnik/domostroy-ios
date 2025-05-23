//
//  Typealiases.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 23.05.2025.
//

typealias EmptyClosure = () -> Void
typealias ToggleClosure = (Bool, _ handler: ((_ success: Bool) -> Void)?) -> Void
typealias HandledClosure = (_ handler: ((_ success: Bool) -> Void)?) -> Void
