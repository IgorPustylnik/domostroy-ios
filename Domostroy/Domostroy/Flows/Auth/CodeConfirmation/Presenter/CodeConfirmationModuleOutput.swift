//
//  CodeConfirmationModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 05/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol CodeConfirmationModuleOutput: AnyObject {
    var onCompleteRegistration: EmptyClosure? { get set }
}
