//
//  MainTabBarViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 03/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol MainTabBarViewOutput {
    /// Notify presenter that user selects some tab
    ///
    /// - Parameter tab: which tab user did select
    /// - Parameter isInitial: flag, indicating that controller was created before
    func selectTab(with tab: MainTab, isInitial: Bool)
    func add()
}
