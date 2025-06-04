//
//  SelectCityModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 01/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol SelectCityModuleOutput: AnyObject {
    var onApply: ((CityEntity?) -> Void)? { get set }
    var onDismiss: EmptyClosure? { get set }
}
