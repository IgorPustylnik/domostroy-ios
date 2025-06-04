//
//  FullScreenImagesModuleInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 01/06/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import Foundation

protocol FullScreenImagesModuleInput: AnyObject {
    func setImages(urls: [URL], initialIndex: Int)
}
