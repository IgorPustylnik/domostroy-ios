//
//  CreateOfferModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 15/04/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import PhotosUI

protocol CreateOfferModuleOutput: AnyObject {
    var onChooseFromLibrary: ((PHPickerViewControllerDelegate, Int) -> Void)? { get set }
    var onTakeAPhoto: ((UIImagePickerControllerDelegate & UINavigationControllerDelegate) -> Void)? { get set }
    var onCameraPermissionRequest: EmptyClosure? { get set }
    var onShowCities: ((CityEntity?) -> Void)? { get set }
    var onShowCalendar: ((LessorCalendarConfig) -> Void)? { get set }
    var onClose: EmptyClosure? { get set }
    var onSuccess: ((Int) -> Void)? { get set }
}
