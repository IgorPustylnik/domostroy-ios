//
//  PermissionHelper.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 16.05.2025.
//

import Foundation
import AVFoundation

final class PermissionHelper {
    static let shared = PermissionHelper()

    private init() {}

    func checkCameraAccess() -> Bool {
        AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }

    func requestCameraAccess(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
}
