//
//  CryptoDashboardViewModel.swift
//  Asset Tracker
//
//  Created by Noor Akhnafal Aban on 18/06/26.
//

import Foundation
import Observation

@Observable
final class CryptoDashboardViewModel {

    private let socket =
        BinanceWebSocketService()

    var currentPrice: Double = 0

    init() {

        socket.onPriceReceived = { [weak self] trade in

            guard let price =
                Double(trade.price)
            else {
                return
            }

            Task { @MainActor in
                self?.currentPrice = price
            }
        }
    }

    func start() {
        socket.connect()
    }

    func stop() {
        socket.disconnect()
    }
}
