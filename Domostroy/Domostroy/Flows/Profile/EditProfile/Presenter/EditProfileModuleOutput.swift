//
//  EditProfileModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 14/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol EditProfileModuleOutput: AnyObject {
    var onShowChangePassword: EmptyClosure? { get set }
    var onSave: EmptyClosure? { get set }
}
