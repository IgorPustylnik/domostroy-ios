//
//  MainTabBarModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

typealias TabSelectClosure = (_ isInitial: Bool) -> Void

protocol MainTabBarModuleOutput: AnyObject {
    var onHomeFlowSelect: TabSelectClosure? { get set }
    var onFavoritesFlowSelect: TabSelectClosure? { get set }
    var onMyOffersFlowSelect: TabSelectClosure? { get set }
    var onRequestsFlowSelect: TabSelectClosure? { get set }
    var onProfileFlowSelect: TabSelectClosure? { get set }
}
