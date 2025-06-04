//
//  EditOfferModuleOutput.swift
//  Domostroy
//
//  Created by igorpustylnik on 15/05/2025.
//  Copyright © 2025 Domostroy. All rights reserved.
//

import PhotosUI

protocol EditOfferModuleOutput: AnyObject {
    var onChooseFromLibrary: ((PHPickerViewControllerDelegate, Int) -> Void)? { get set }
    var onTakeAPhoto: ((UIImagePickerControllerDelegate & UINavigationControllerDelegate) -> Void)? { get set }
    var onCameraPermissionRequest: EmptyClosure? { get set }
    var onShowCities: ((CityEntity?) -> Void)? { get set }
    var onClose: EmptyClosure? { get set }
    var onChanged: EmptyClosure? { get set }
}
