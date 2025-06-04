//
//  SelectCityModuleInput.swift
//  Domostroy
//
//  Created by igorpustylnik on 01/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

protocol SelectCityModuleInput: AnyObject {
    func setInitial(city: CityEntity?)
    func setAllowAllCities(_ allow: Bool)
}
