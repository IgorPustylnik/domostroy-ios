//
//  InfoPlist.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 08.04.2025.
//

import Foundation

enum InfoPlist {
    static var serverHost = Bundle.main.infoDictionary?["SERVER_HOST"] as? String
}
