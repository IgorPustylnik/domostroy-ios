//
//  RegisterModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 05/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol RegisterModuleOutput: AnyObject {
    var onReceiveCode: ((RegisterDTO) -> Void)? { get set }
    var onDismiss: EmptyClosure? { get set }
}
