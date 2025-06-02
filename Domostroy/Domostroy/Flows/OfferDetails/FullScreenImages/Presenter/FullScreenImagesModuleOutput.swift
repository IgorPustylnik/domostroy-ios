//
//  FullScreenImagesModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 01/06/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol FullScreenImagesModuleOutput: AnyObject {
    var onDismiss: EmptyClosure? { get set }
    var onScrollTo: ((Int) -> Void)? { get set }
}
