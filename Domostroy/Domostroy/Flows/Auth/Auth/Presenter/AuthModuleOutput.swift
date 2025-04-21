//
//  AuthModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 04/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol AuthModuleOutput: AnyObject {
    var onLogin: EmptyClosure? { get set }
    var onRegister: EmptyClosure? { get set }
    var onDeinit: EmptyClosure? { get set }
}
