//
//  AdminPanelModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 21/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol AdminPanelModuleOutput: AnyObject {
    var onPresentSegment: ((AdminPanelPresenterModel.Segment) -> Void)? { get set }
}
