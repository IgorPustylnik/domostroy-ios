//
//  AdminPanelViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 21/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol AdminPanelViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func selectSegment(_ index: Int)
}
