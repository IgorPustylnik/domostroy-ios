//
//  FullScreenImagesViewOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 01/06/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol FullScreenImagesViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()
    func scrolledTo(index: Int)
    func dismiss()
}
