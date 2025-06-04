//
//  ProfileBannedModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 04/06/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol ProfileBannedModuleOutput: AnyObject {
    var onLogout: EmptyClosure? { get set }
    var onUnbanned: EmptyClosure? { get set }
}
