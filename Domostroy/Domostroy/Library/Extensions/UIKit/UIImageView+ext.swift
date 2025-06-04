//
//  UIImageView+ext.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 14.05.2025.
//

import UIKit
import Kingfisher

extension UIImageView {
    func loadAvatar(id: Int, name: String, url: URL?) {
        DispatchQueue.main.async { [weak self] in
            self?.kf.setImage(with: url, placeholder: UIImage.initialsAvatar(name: name, hashable: id))
        }
    }
}
