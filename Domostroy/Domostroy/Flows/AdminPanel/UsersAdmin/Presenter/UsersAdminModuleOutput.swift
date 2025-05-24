//
//  UsersAdminModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 21/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol UsersAdminModuleOutput: AnyObject {
    var onOpenUser: ((Int) -> Void)? { get set }
    func getSearchQuery() -> String?
}
