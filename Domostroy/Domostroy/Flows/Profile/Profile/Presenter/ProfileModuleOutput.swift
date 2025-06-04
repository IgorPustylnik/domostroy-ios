//
//  ProfileModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol ProfileModuleOutput: AnyObject {
    var onEdit: EmptyClosure? { get set }
    var onAdminPanel: EmptyClosure? { get set }
    var onSettings: EmptyClosure? { get set }
    var onShowBanned: EmptyClosure? { get set }
    var onLogout: EmptyClosure? { get set }
}
