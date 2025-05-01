//
//  CreateOfferModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 15/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import UIKit
import PhotosUI

protocol CreateOfferModuleOutput: AnyObject {
    var onAddImages: ((PHPickerViewControllerDelegate, Int) -> Void)? { get set }
    var onShowCities: ((CityEntity?) -> Void)? { get set }
    var onShowCalendar: ((LessorCalendarConfig) -> Void)? { get set }
    var onClose: EmptyClosure? { get set }
}
