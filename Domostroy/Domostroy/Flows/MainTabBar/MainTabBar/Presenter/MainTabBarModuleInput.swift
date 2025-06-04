//
//  MainTabBarModuleInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol MainTabBarModuleInput: AnyObject {
    func setCenterControl(enabled: Bool)
    func selectTab(_ tab: MainTab)
}
