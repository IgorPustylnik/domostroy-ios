//
//  RealNetworkMonitor.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 01.06.2025.
//

import Foundation

final class RealNetworkMonitor: NetworkMonitor {
    private var timer: Timer?
    private let checkInterval: TimeInterval = 5

    private(set) var isConnected: Bool = true

    var onStatusChange: ((Bool) -> Void)?

    func start() {
        stop()

        let timer = Timer(
            timeInterval: checkInterval,
            repeats: true
        ) { [weak self] _ in
            self?.checkConnection()
        }
        self.timer = timer
        RunLoop.main.add(timer, forMode: .common)

        checkConnection()
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    func checkConnection(completion: EmptyClosure?) {
        guard let url = URL(string: "https://ya.ru") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        request.timeoutInterval = 3

        URLSession.shared.dataTask(with: request) { [weak self] _, response, error in
            let success = (200...299).contains((response as? HTTPURLResponse)?.statusCode ?? 0)
            self?.handleConnectionChange(connected: success)
            completion?()
        }.resume()
    }

    private func handleConnectionChange(connected: Bool) {
        if self.isConnected != connected {
            self.isConnected = connected
            self.onStatusChange?(connected)
        }
    }
}
