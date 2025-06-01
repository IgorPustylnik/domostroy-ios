//
//  NetworkMonitor.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 01.06.2025.
//

import Network

protocol NetworkMonitor {
    var isConnected: Bool { get }
    var onStatusChange: ((Bool) -> Void)? { get set }

    func checkConnection(completion: EmptyClosure?)
    func start()
    func stop()
}

extension NetworkMonitor {
    func checkConnection() {
        checkConnection(completion: nil)
    }
}
